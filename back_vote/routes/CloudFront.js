const path = require('path');
const express = require('express');
const router = express.Router();
const dotenv = require("dotenv")
const { getSignedUrl } = require("@aws-sdk/cloudfront-signer")
const { S3Client, ListObjectsCommand } = require("@aws-sdk/client-s3")
const User = require("../model/user")

dotenv.config()
const bucketName = process.env.AWS_BUCKET_NAME
const region = process.env.AWS_BUCKET_REGION
const accessKeyId = process.env.AWS_ACCESS_KEY
const secretAccessKey = process.env.AWS_SECRET_ACCESS_KEY

const s3Client = new S3Client({
      region,
      credentials: {
            accessKeyId,
            secretAccessKey
      }
})

router.get("/electioncomission/service", async (req, res) => {
      var file = [];
      const command = new ListObjectsCommand({
            Bucket: bucketName,
            Key: 'uploads/'
      });
      const result = await s3Client.send(command);
      result['Contents'].forEach((filename, index) => {
            // console.log(filename['Key']);
            file.push(filename['Key'])

      })
      var url = [];
      for (var i = 0; i < 4; i++) {

           // console.log(file[i])
            const signedUrl = getSignedUrl({
                  keyPairId: process.env.CLOUDFRONT_KEYPAIR_ID,
                  privateKey: process.env.CLOUDFRONT_PRIVATE_KEY,
                  url: "https://dmyffzfx34jxl.cloudfront.net/" + file[i],
                  dateLessThan: new Date(Date.now() + (1000 * 60 * 60 * 24))
            })
           // console.log(signedUrl)
            url.push(signedUrl)
      }
      // console.log(url[0])
      var AddharNumber = url[0].split('/')[4];

       console.log(AddharNumber)
      var user = await User.findOne({AddharNumber: AddharNumber});
      console.log(user)
      var Phone = user.Phone;
      var Email = user.Email;
      var Fname =user.Fname;
      var Lname = user.Lname;
      // console.log(AddharNumber,Phone,Email,Fname,Lname)
      res.render('service', { url , AddharNumber,Phone,Email,Lname,Fname})
})

module.exports = router ;