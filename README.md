### Antony Bluemel

# PayMate - An iOS Digital Mobile Wallet App Built with SwiftUI

## Description
Welcome to PayMate, an innovative digital mobile wallet application (app) designed with a strong emphasis on animations and user interface (UI). This app offers a seamless and visually engaging experience for managing digital transactions with ease. Developed for both tech-savvy users and beginners alike, PayMate stands out with its unique animation-focused UI and intuitive design.

## Features
### 1. Dark Mode Support
<img src="https://github.com/discotony/PayMate/blob/main/ReadMeAssets/DarkMode.gif" width="277" height="600"/>
PayMate is built with a dark mode feature, providing a user-friendly interface that's easy on the eyes, especially in low-light environments. This mode not only enhances visual comfort but also extends battery life on OLED displays.

---

### 2. UI Elements Animation
<img src="https://github.com/discotony/PayMate/blob/main/ReadMeAssets/KeyboardAnimation.gif" width="277" height="600"/>
Experience smooth animations of UI elements as the keyboard appears and disappears. This feature ensures a fluid and responsive user experience, maintaining a consistent and elegant interface throughout.

---

### 3. Custom Launch Screen Animation
<img src="https://github.com/discotony/PayMate/blob/main/ReadMeAssets/LaunchAnimation.gif" width="277" height="600"/>
The launch screen sets the tone for a dynamic experience with custom animations. Each image element is animated by configuring offsets, angles, speed, and directions from scratch, showcasing the commitment to a high-quality, library-independent approach.

---

### 4. Animated Sign-In Screen
<img src="https://github.com/discotony/PayMate/blob/main/ReadMeAssets/SignIn.gif" width="277" height="600"/>
The Sign-In screen features captivating animations for the welcome text and image. These elements are programmatically implemented, creating an inviting and interactive entry point into the app without relying on third-party libraries.

---

### 5. Optimized for Smaller Devices
<img src="https://github.com/discotony/PayMate/blob/main/ReadMeAssets/SmallDevice.gif" width="277" height="492.5"/>
PayMate is designed to support smaller devices efficiently. On screens with limited space, certain UI elements automatically disappear, prioritizing essential content while maintaining design consistency and user friendliness.

---

### 6. OTP Screen with Animation
<img src="https://github.com/discotony/PayMate/blob/main/ReadMeAssets/OTP.gif" width="277" height="600"/>
The One-Time Password (OTP) screen includes custom animations for an enhanced user experience. Like other features, these animations are developed programmatically, ensuring a unique and cohesive look and feel.

---

### 7. Advanced Error Handling
PayMate smartly handles various error types related to phone number input:

- **Error Type 1**: Alerts for phone numbers that are too short or too long.

<img src="https://github.com/discotony/PayMate/blob/main/ReadMeAssets/TooShortOrTooLong.gif" width="277" height="600"/>

- **Error Type 2**: Notification for phone numbers starting with one.

<img src="https://github.com/discotony/PayMate/blob/main/ReadMeAssets/StartsWithOne.gif" width="277" height="600"/>

- **Error Type 3**: Validation using the [PhoneNumberKit](https://github.com/marmelroy/PhoneNumberKit) Swift framework for incorrect phone numbers.

<img src="https://github.com/discotony/PayMate/blob/main/ReadMeAssets/InvalidNumber.gif" width="277" height="600"/>

Status messages for these errors are displayed in real-time, guiding users in formatting while deactivating the submit button for incorrect inputs.

---

### 8. Successful Input Notification
<img src="https://github.com/discotony/PayMate/blob/main/ReadMeAssets/ValidNumber.gif" width="277" height="600"/>
Upon entering a valid phone number, users are promptly notified with a pop-up view, confirming the successful input and readying them for the next step in their PayMate experience.

---

### 9. OTP Style Text Field & Auto-Focus Movement
<img src="https://github.com/discotony/PayMate/blob/main/ReadMeAssets/delete.gif" width="277" height="600"/>

- When users receive an OTP, they will notice it's displayed in a unique style - six separate boxes, each containing one digit. This format is not only visually appealing but also makes it easier to track which digit users are on.

- As users enter the OTP, our app smartly moves the focus to the next text field after each digit is entered. Similarly, if users need to delete a digit, the focus automatically shifts back to the previous text field. This intuitive navigation saves time and reduces the chances of input errors.

---

### 10. OTP Auto-Verification
<img src="https://github.com/discotony/PayMate/blob/main/ReadMeAssets/correctOTP.gif" width="277" height="600"/>
Say goodbye to the hassle of pressing a 'Next' or 'Verify' button after entering users' OTP. Our app automatically verifies the code as soon as all six digits are entered. If the code is correct, you'll be directly taken to the main home page, ensuring a smooth and efficient login process.

---

### 11. Resend OTP Functionality
<img src="https://github.com/discotony/PayMate/blob/main/ReadMeAssets/resend.gif" width="277" height="600"/>
If users did not receive the OTP or need it resent for any reason, our app has users covered. Simply tap the 'Resend' button, and a new verification code will be sent to the phone number users provided at the login stage. This feature is designed to make sure users are never stuck at the verification stage.

---

### 12. Instant Error Handling
<img src="https://github.com/discotony/PayMate/blob/main/ReadMeAssets/incorrectOTP.gif" width="277" height="600"/>
If the entered OTP is invalid, an error message promptly appears. This feature ensures that users are immediately informed of any input errors, allowing users to correct them without delay.

---

### 13. Phone Pad and Autofill
Our digital wallet app exclusively presents a phone pad for numeric input, making it easier and faster to enter users' OTP. Plus, with the autofill functionality, the app can automatically fill in the OTP for users. This means if users' device receives the OTP via SMS, it can be auto-filled without any manual input, streamlining the verification process.

---

### 14. Persistent User Session
<img src="https://github.com/discotony/PayMate/blob/main/ReadMeAssets/persistLogIn1.gif" width="277" height="600"/>
<img src="https://github.com/discotony/PayMate/blob/main/ReadMeAssets/persistLogIn2.gif" width="277" height="600"/>
Our digital wallet app utilizes an authorization token to retain user information after the initial login with a One-Time Password (OTP), ensuring seamless access in future sessions.

---

### 15. HomeView: Account Information Dashboard
<img src="https://github.com/discotony/PayMate/blob/main/ReadMeAssets/dashboard.gif" width="277" height="600"/>
Our digital wallet app displays total assets, the balance of each account, and the user's name, offering a snapshot of your financial status at a glance.

---

### 16. Settings Page: Username Update
<img src="https://github.com/discotony/PayMate/blob/main/ReadMeAssets/dashboard.gif" width="277" height="600"/>
Our digital wallet app automatically enables the save option when a new username is typed into the text field, facilitating easy updates without additional steps.

---

### 16. Secure Logout with Confirmation Alert
<img src="https://github.com/discotony/PayMate/blob/main/ReadMeAssets/logout.gif" width="277" height="600"/>
Our digital wallet app prevents accidental logout and features a confirmation alert when logging out, ensuring that users only exit the app intentionally.

---
