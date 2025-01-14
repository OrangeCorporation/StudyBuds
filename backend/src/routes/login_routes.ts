import { Strategy as SamlStrategy } from "@node-saml/passport-saml";
import { Request, Response, Router } from "express";
import passport from "passport";
import { fetch, toPassportConfig } from "passport-saml-metadata";
import { ENTITY_ID, IDP_ENTRYPOINT, IDP_METADATA } from "../config/unigeapi";
import { validateInt } from "../utils/validation_error";
import { generateToken } from "../service/login_service";

const router: Router = Router();


async function getMetadata() {
    const reader = await fetch({ url: IDP_METADATA });

    const config = toPassportConfig(reader);

    passport.use(
        new SamlStrategy(
            {
                ...config,
                entryPoint: IDP_ENTRYPOINT,
                callbackUrl: "l", // it has to be not empty string | unused
                issuer: ENTITY_ID,
                // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
                idpCert: config.idpCert,
                disableRequestedAuthnContext: true,
            },
            function (profile: unknown, done: (error: null, user?: unknown) => void) {
                return done(null, profile);
            },
            function (profile: unknown, done: (error: null, user?: unknown) => void) {
                return done(null, profile);
            }
        )
    );
}

getMetadata().catch(console.error);

// eslint-disable-next-line @typescript-eslint/no-unsafe-argument
router.get("/", passport.authenticate("saml"));

// eslint-disable-next-line @typescript-eslint/no-unsafe-argument
router.post("/", passport.authenticate("saml", { session: false }), (req: Request, res: Response) => {
    const token = generateToken(req.user);
    // res.redirect(`myapp://auth?token=${token}`);
    res.send(`
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Redirecting...</title>
        </head>
        <body>
            <script>
                // Redirect to the app's callback URL
                window.location.href = "myapp://auth?token=${token}";

                // Close the WebView after a short delay
                setTimeout(() => {
                    window.close();
                }, 500);
            </script>
            <p>Redirecting, please wait...</p>
        </body>
        </html>
    `);
});

export default router;
