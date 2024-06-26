import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:pap_care_management/styles/question_style.dart';

class FormOnetest extends StatefulWidget {
  const FormOnetest({Key? key});

  @override
  State<FormOnetest> createState() => _FormOnetestState();
}

class _FormOnetestState extends State<FormOnetest> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool autoValidate = true;
  bool readOnly = false;
  final List<bool> _questionStates = List.generate(42, (_) => true); // Initialize all states as false


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
              // const SizedBox(height: 20),
              // Generated FormBuilderTextField widgets for questions Q1 to Q11
              ..._buildFormFields(),
              
              MaterialButton(
                color: Theme.of(context).colorScheme.secondary,
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _formKey.currentState!.saveAndValidate();
                  debugPrint(_formKey.currentState?.instantValue.toString() ?? '');
                },
              ),
            ],
          ),
        ),
      );

  }

  List<Widget> _buildFormFields() {
    List<Widget> formFields = [];

    for (int i = 0; i < 42; i++) {
      formFields.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 27),
            QuestionText(text: _questions[i], questionNumber: i+1,),
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

void _scrollListener() {
    // Scroll listener if needed
  }
const _questions = [
  "Total No. of Bed Bound Patients in Last Month",
  "New Bed Bound Patients",
  "Expired or Transfer out Case",
  "Total no. of Bed Bound Patients",
  "Total No. of Home Care Days",
  "No of Bed Bound Patients Visited in this month ",

  "Total No of Patients Visited in this month",
  "No of Patients Seen by the Doctor - MM",
  "No of Patients Seen by the Physiotherapist ",
  "New Home Bound and Chronic illness Patients With SHS",
  "Total No .of Home Bound and Chronic Illness Patients With SHS",
  "No of Home Bound & Chronic Illness with SHS given Priority  Visit from JAK",

  "Total Patients on Follow-up Care ",
  "How many Volunteers where linked to Patients ",
  "No of Volunteers Completed 3 Days Training So far  within your LSGD",
  "No of Volunteers Completed 3 Days Training in this Month   Within your LSGD",
  "Number of Patients Seen by the  Doctor ISM",
  "Number of Patients Seen by the  Doctor Homoeo",

  "Number of LSGDI's Members attend Home care",
  "Number of Health Staff attend Home care",
  "Number of ASHA Workers attend Home care",
  "Number of Community Volunteers attend Home care",
  "Bath",
  "Mouth Care",

  "Catheterization",
  "No of indwelling catheter",
  "Bladder wash",
  "Wound dressing",
  "PRE Enema",
  "Cancer",
  
  "CKD Patients",
  " Dialysis Patient",
  "Paraplegia +Quadriplegia",
  "Hemi Plegia",
  "Riles tube",
  "Colostomy",

  "Tracheotomy",
  "Lymphedema",
  "0-18 year",
  "18-60 Year",
  ">60 yrs",
  "No. of Patients taking Morphine",
] ;



 // Initialize all states as false


