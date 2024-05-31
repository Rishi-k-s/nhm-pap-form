import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:pap_care_management/styles/question_style.dart';

// import 'package:http/http.dart' as http;
// import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';
class HospitalForm extends StatefulWidget {
  final String selectedInstitution;
  final String selectedLocation;

  // const HospitalForm({
  //   super.key,
  // });


  const HospitalForm({Key? key, required this.selectedInstitution, required this.selectedLocation}) : super(key: key);
  @override
  State<HospitalForm> createState() => _HospitalFormState();
}

class _HospitalFormState extends State<HospitalForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final db = FirebaseFirestore.instance;

  
  bool autoValidate = true;
  bool readOnly = false;
  String queryString = '';
  String? eachQuestion = '';
  String firstFormElem ='';
  final List<bool> _questionStates = List.generate(_questions.length, (_) => true); // Initialize all states as false
 //                                                 ^ chnage the no of qns



 Future<List> _instituteLocationSharedPrefReciver()async{
    String? _institute;
    String? _location;
    SharedPreferences prefs = await _prefs;
    setState(() {
        _institute = (prefs.getString('Institute') ?? "No data received");
        _location = (prefs.getString('Location') ?? "No data received");
        debugPrint(_institute.toString());
        debugPrint(_location.toString());
    });

    return [_institute,_location];
  }

void _emailCreateUser(String emailAddress, String password)async {
        try {
          final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );
          debugPrint(credential.toString());
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            print('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            print('The account already exists for that email.');
          }
        } catch (e) {
          print(e);
        }
}
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          onChanged: () {
            _formKey.currentState!.save();
            debugPrint(_formKey.currentState!.value.toString());
          },
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Container(
              //   child: Text(widget.message),
              // ),
              // const SizedBox(height: 20),
              // Generated FormBuilderTextField widgets for questions Q1 to Q11
              ..._buildFormFields(),
              
              MaterialButton(
                color: Theme.of(context).colorScheme.secondary,
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  _formKey.currentState!.saveAndValidate();
                  debugPrint(_formKey.currentState?.instantValue.toString() ?? '');
                  Map<String, dynamic>? formData = _formKey.currentState?.instantValue;
                  List instituteLocationList = await _instituteLocationSharedPrefReciver();

                  final quesionsListWithInstituteAndLocation = {
                  "Institute": instituteLocationList[0],
                  "Location": instituteLocationList[1],
                  "Status": true,
                  "timestamp": FieldValue.serverTimestamp()
                  };

                  for(int i=1; i< _questions.length; i++){
                    eachQuestion = formData?["Q$i"];
                    quesionsListWithInstituteAndLocation['Q$i'] = eachQuestion;
                  }

                  debugPrint(quesionsListWithInstituteAndLocation.toString());

                  db.collection(instituteLocationList[0]) // institution
                    .doc(instituteLocationList[1]) //location
                    .set(quesionsListWithInstituteAndLocation)
                    .onError((e, _) => debugPrint("Error writing document: $e"));

                  // _emailCreateUser("rishikrishna.sr@gmail.com","qwe123asd");

                 




                  // for(int i=1; i< 27;i++){
                  //   // debugPrint(formData?["Q$i"]);
                  //   eachQuestion = formData?["Q$i"];
                  //   queryString  += "&Q$i=$eachQuestion";
                  // }
                  // // eachQuestion = "?Q1=Rishi&Q2=M&Q3=22";

                  // firstFormElem = formData?["Q0"];
                  // String firstElem = "?Q0=$firstFormElem";

                  // String scriptURL  = AppScriptString().theAppScriptUrl;
                  // var finalURI   = Uri.parse(scriptURL + firstElem +queryString);
                  // // var finalURI   = Uri.parse(scriptURL + eachQuestion);
                  // var response    = await http.get(finalURI);

                  // debugPrint(finalURI.toString());
                  // debugPrint(widget.selectedInstitution);
                  // debugPrint(widget.selectedLocation);

                  // queryString = "";

                  // if (response.statusCode == 200) {
                  //   var bodyR = convert.jsonDecode(response.body);
                  //   debugPrint(bodyR.toString());
                  // }


                    //TODO(wdas): put this to appscrpt
                  // if(_formKey.currentState!.saveAndValidate() == true){}
                  // if (formData != null) {
                  //       String? q0Value = formData["Q0"];
                  //       String? q1Value = formData["Q1"];
                  //       debugPrint(q0Value );
                  //       // Access other field values in a similar way
                  //     }
                },
              ),
            ],
          ),
        ),
      );

  }

  List<Widget> _buildFormFields() {
    List<Widget> formFields = [];

    for (int i = 0; i < _questions.length; i++) { // the i repersent the number of questions, chnaege in up too
      formFields.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 27),
            QuestionText(text: _questions[i],questionNumber: i+1,),
            FormBuilderTextField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              name: "Q$i",
              decoration: InputDecoration(
                suffixIcon: _questionStates[i]
                    ? const Icon(Icons.error, color: Colors.red)
                    : const Icon(Icons.check, color: Colors.green),
              ),
              onChanged: (val) {
                setState(() {
                  _questionStates[i] =
                      !(_formKey.currentState?.fields['Q$i']?.validate() ?? false);
                });
                
              },
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.numeric(),
                FormBuilderValidators.max(10000),
              ]),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
          ],
        ),
      );
    }

    return formFields;
  }

}

// const _questions = [
//   "Total No. of Bed Bound Patients in Last Month",
//   "New Bed Bound Patients",
//   "Expired or Transfer out Case",
//   "Total no. of Bed Bound Patients",
//   "Total No. of Home Care Days",
//   "No of Bed Bound Patients Visited in this month ",

//   "Total No of Patients Visited in this month",
//   "No of Patients Seen by the Doctor - MM",
//   "No of Patients Seen by the Physiotherapist ",
//   "New Home Bound and Chronic illness Patients With SHS",
//   "Total No .of Home Bound and Chronic Illness Patients With SHS",
//   "No of Home Bound & Chronic Illness with SHS given Priority  Visit from JAK",

//   "Total Patients on Follow-up Care ",
//   "How many Volunteers where linked to Patients ",
//   "No of Volunteers Completed 3 Days Training So far  within your LSGD",
//   "No of Volunteers Completed 3 Days Training in this Month   Within your LSGD",
//   "Number of Patients Seen by the  Doctor ISM",
//   "Number of Patients Seen by the  Doctor Homoeo",

//   "Number of LSGDI's Members attend Home care",
//   "Number of Health Staff attend Home care",
//   "Number of ASHA Workers attend Home care",
//   "Number of Community Volunteers attend Home care",
//   "Bath",
//   "Mouth Care",

//   "Catheterization",
//   "No of indwelling catheter",
//   "Bladder wash",
//   "Wound dressing",
//   "PRE Enema",
//   "Cancer",
  
//   "CKD Patients",
//   " Dialysis Patient",
//   "Paraplegia +Quadriplegia",
//   "Hemi Plegia",
//   "Riles tube",
//   "Colostomy",

//   "Tracheotomy",
//   "Lymphedema",
//   "0-18 year",
//   "18-60 Year",
//   ">60 yrs",
//   "No. of Patients taking Morphine",
// ] ;

const _questions = [
"Number of units with trained (BCCPM / 10 days) charge medical officer",
"Number of units with trained (BCCPN / 10 days) charges Nursing Officer",
"New Patients of Follow up in the month",
"No of patients on Follow up at the End of the month",
"Total no of Home care days",
"Total No. of Patients Visited by Staff Nurse",
"Total No. of Patients Visited by Doctor",
"Number of Ascetic tapping at Home",
"Special OP attendance",
"No. of institutions having morphine license",
"Total number of Patients given morphine",
"Total No of patients given IP care",
"Catheterization",
"No of patients given Colostomy materials",
"No of Health Professionals completed 3 days training in this month",
"No. of Nursing Students Completed 3 Days Training in this Month",
"Mouth Care",
"Parenteral Fluid / Medicine",
"Wound Care",
"PRE Enema",
"Riles tube",
"Colostomy Care",
"Tracheotomy Care",
"Lymph edema",
"No. of Care Homes in the Secondary Area",
"No. of Care Homes Visit",
"Other Innovative Programs"
];

 // Initialize all states as false

