import { Router } from "express";
import courseRoutes from "./courseRoutes";
import groupRoutes from "./groupRoutes";
import notification from "./notificationRoutes";
import profileRoutes from "./profileRoutes";
import studentRoutes from "./studentRoutes";
import loginRoutes from "./loginRoutes";

const router: Router = Router();

// Handle favicon requests to prevent unnecessary processing
router.get("/favicon.ico", (req, res) => {
    res.status(204).end(); // No Content
});

// Root route
router.get("/", (req, res) => {
    res.send("Welcome to the StudyBuds API!");
});

router.use("/profile", profileRoutes);

// Mount student routes under "/students"
router.use("/students", studentRoutes);

// Mount group routes under "/groups"
router.use("/groups", groupRoutes);

router.use("/login", loginRoutes);

// Mount course routes under "/courses"
router.use("/courses", courseRoutes);

// Mount course routes under "/notification"
router.use("/notification", notification);

export default router;
