const express = require('express');
const router = express.Router();
const User = require("../model/user")

router.post('/data',async (req, res) => {
      console.log("Result",req.body)
      
      const { Fname, Lname, Email, Phone, AddharNumber , fcm_token } = req.body;
      const newUser = new User({
            Fname,
            Lname,
            Email,
            Phone,
            AddharNumber,
            fcm_token
        });
        const savedUser = await newUser.save();
        console.log("Final",savedUser)
      res.status(200).send({
            "statuscode":200,
            "message":"User data added Succesfully But Not verify",
            "data":savedUser
      })
})

module.exports = router;