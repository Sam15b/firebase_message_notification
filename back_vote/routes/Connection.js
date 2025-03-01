const path = require('path');
const express = require('express');
const router = express.Router();

router.get("/", async (req, res) => {
      res.render("main_page")
})

router.get("/sign-in", async (req, res) => {
      res.render("sign_in")
})

module.exports = router;