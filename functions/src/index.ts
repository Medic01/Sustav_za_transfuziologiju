import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as nodemailer from "nodemailer";

admin.initializeApp();

// Create a Nodemailer transporter
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "markomedic834@gmail.com",
    pass: "fagw wbbb qlbc mzjp",
  },
});

exports.sendNotification = functions.firestore
.document("blood_donation/{donationId}")
.onUpdate((change) => {
  const newValue = change.after.data();
  const previousValue = change.before.data();

  if (
    previousValue.status === "PENDING" &&
    (newValue.status === "ACCEPTED" || newValue.status === "REJECTED")
  ) {
    // Send email
    const mailOptions = {
      from: "markomedic834@gmail.com",
      to: "marko.medic275@gmail.com",
      subject: "Blood donation status changed",
      text: `Your blood donation status has changed to ${newValue.status}`,
    };
    return transporter.sendMail(mailOptions)
      .then((info) => {
        console.log(`Email sent: ${info.response}`);
        return null;
      });
  }
});
