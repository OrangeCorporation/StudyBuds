// Node.js Example
import { Router } from "express";
import passport from "passport";
import { Strategy as SamlStrategy } from "@node-saml/passport-saml";
import { fetch, MetadataReader, toPassportConfig, claimsToCamelCase } from "passport-saml-metadata";
import jwt from "jsonwebtoken";

const router: Router = Router();

const url = process.env.IDP_METADATA;

async function getMetadata() {
    const reader = await fetch({ url });

    const config = toPassportConfig(reader);

    passport.use(
        new SamlStrategy(
            {
                ...config,
                entryPoint: process.env.IDP_ENTRYPOINT,
                callbackUrl: "l",
                issuer: "saml-poc",
                idpCert: config.idpCert,
                disableRequestedAuthnContext: true,
            },
            function (profile: any, done: (error: any, user?: any) => void) {
                return done(null, profile);
            },
            function (profile: any, done: (error: any, user?: any) => void) {
                return done(null, profile);
            }
        )
    );
}

getMetadata();

router.get("/", passport.authenticate("saml"));

router.post("/", passport.authenticate("saml", { session: false }), (req, res) => {
    const token = jwt.sign({ user: req.user }, process.env.JWT_SECRET!, { expiresIn: "1h" });
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
