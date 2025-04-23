const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.createUserWithProfile = functions.https.onCall(async (data, context) => {
  // ✅ Auth check: only authenticated users
  const callerUid = context.auth && context.auth.uid;
  if (!callerUid) {
    throw new functions.https.HttpsError("unauthenticated", "You must be signed in.");
  }

  // ✅ Role check: only admins can create users
  const callerDoc = await admin.firestore().collection("users").doc(callerUid).get();
  const callerData = callerDoc.data();
  const callerRole = callerData && callerData.role;
  if (callerRole !== "admin") {
    throw new functions.https.HttpsError("permission-denied", "Only admins can create users.");
  }

  // ✅ Validate input
  const requiredFields = ["email", "password", "name", "company_id", "department", "position", "role"];
  for (const field of requiredFields) {
    if (!data[field]) {
      throw new functions.https.HttpsError("invalid-argument", `Missing field: ${field}`);
    }
  }

  const { email, password, name, company_id, department, position, role } = data;

  // ✅ Create user in Firebase Auth
  const userRecord = await admin.auth().createUser({
    email: email,
    password: password,
    displayName: name,
  });

  // ✅ Store user profile in Firestore
  await admin.firestore().collection("users").doc(userRecord.uid).set({
    email: email,
    name: name,
    company_id: company_id,
    department: department,
    position: position,
    role: role,
    join_date: new Date().toISOString(),
    last_check_in: null,
  });

  return { success: true, uid: userRecord.uid };
});
