import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:pap_care_management/app_secrets/codepage.dart';
import 'package:pap_care_management/pages/coming_soon_page.dart';
import 'package:pap_care_management/pages/form_pages/chc_form.dart';
// import 'package:pap_care_management/pages/form_pages/lsgd_form.dart';
import 'package:pap_care_management/pages/form_pages/hospital_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'form_pages/admin_dashboard.dart';

class RelatedFields extends StatefulWidget {
  const RelatedFields({super.key});

  @override
  State<RelatedFields> createState() => _RelatedFieldsState();
}

class _RelatedFieldsState extends State<RelatedFields> {
  final _formKey = GlobalKey<FormBuilderState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String selectedInstitution = 'CHC'; // Default selection for institution
  String selectedLocation = ''; // Default selection for location

  // static const Widget sdj = Text("Oiiiii",textAlign: TextAlign.center,style: const TextStyle(color: Colors.amber),);

  // List of institutions and their corresponding locations
  static const Map<String, List<String>> institutionToLocations = {
    'CHC': ["CHERUVADI", "CHERUVANNUR", "KODENCHERY", "KODUVALLI", "KOORACHUNDU", "KUNNUMMAL", "MELADY", "MUKKAM", "NARIKUNI", "OLAVANNA", "ORKATERY", "THALAKULATHUR", "THIRUVALLUR", "THIRUVANGOOR", "ULLIYERI", "VALAYAM"],
    'Hospital': ["DH VADAKARA","GGH KOZHIKODE", "TH KOYILANDY", "TH NADAPURAM", "TH KUTTYADI", "TH PERAMBRA", "TH BALUSSERI", "TH THAMARASSERI"],
    'LSGD' : [
    "Arikkulam", "Atholi", "Ayancheri", "Azhiyur", "Balusseri", "Changaroth", "Chathamangalam", "Chekkittapara", "Chekkiyad", "Chelannur", "Chemancheri", "Chengottukave", "Cheruvannur", "Chorode", "Corporation Unit 1", "Corporation Unit 2", "Corporation Unit 3", "Edacheri", "Eramala", "Feroke",
    "Kadalundi", "Kakkodi", "Kakkur", "Karasseri", "Kattippara", "Kavilumpara", "Kayakkodi", "Kayanna", "Keezhariyur", "Kizhakkoth", "Kodancheri", "Kodiyathur", "Koduvalli", "Koodaranhi", "Koorachundu", "Koothali", "Kottur", "Koyilandy Unit 1", "Koyilandy Unit 2", "Kunnamangalam",
    "Kunnummal", "Kuruvattur", "Kuttyadi", "Madavoor", "Maniyur", "Maruthonkara", "Mavoor", "Meppayoor", "Moodadi", "Mukkam", "Nadapuram", "Naduvanur", "Nanminda", "Narikkuni", "Narippatta", "Nochad", "Olavanna Unit 1", "Olavanna Unit 2", "Omassery", "Onchiyam",
    "Panangad Unit 1", "Panangad Unit 2", "Payyoli Unit 1", "Payyoli Unit 2", "Perambra", "Perumanna", "Peruvayal", "Puramery", "Puthuppadi", "Ramanattukara", "Thalakulathur", "Thamarasseri", "Thikkodi", "Thiruvallur", "Thiruvambadi", "Thuneri", "Thurayur", "Ulliyeri", "Unnikulam", "Vadakara Unit 1",
    "Vadakara Unit 2", "Valayam", "Vanimel", "Velom", "Villyapalli"
    ],

  };

  Future<bool> _instituteLocationSharedPrefSender(String currentInst, String currentLocation)async{
    SharedPreferences prefs = await _prefs;
    prefs.setString("Institute", currentInst);
    prefs.setString("Location", currentLocation);
    return true;
  }

  @override
  void initState() {
    super.initState();
    selectedLocation = institutionToLocations[selectedInstitution]?.first ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          FormBuilderDropdown<String>(
            name: 'institution',
            decoration: const InputDecoration(label: Text("Institution")),
            initialValue: selectedInstitution,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedInstitution = value;
                  selectedLocation = institutionToLocations[value]?.first ?? '';
                });
              }
            },
            items: institutionToLocations.keys.map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                )).toList(),
          ),
          const SizedBox(height: 10),
          FormBuilderDropdown<String>(
            name: 'location',
            decoration: const InputDecoration(label: Text('Location')),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
            initialValue: selectedLocation,
            onChanged: (value) => setState(() => selectedLocation = value ?? ''),
            items: (institutionToLocations[selectedInstitution] ?? []).map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                )).toList(),
          ),
          const SizedBox(height: 10),
          MaterialButton(
            color: Theme.of(context).colorScheme.secondary,
            child: const Text("Submit", style: TextStyle(color: Colors.white)),
            onPressed: () {
              if(selectedInstitution == "CHC"){
                if (_formKey.currentState?.saveAndValidate() ?? false) {
                debugPrint(_formKey.currentState?.instantValue.toString() ?? '');
                _instituteLocationSharedPrefSender(selectedInstitution,selectedLocation);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CodePage(title: 'CHC level', child: FormOne()))
                );
              }
              } else if(selectedInstitution == "Hospital"){
                if (_formKey.currentState?.saveAndValidate() ?? false) {
                debugPrint(_formKey.currentState?.instantValue.toString() ?? '');
                _instituteLocationSharedPrefSender(selectedInstitution,selectedLocation);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CodePage(title: 'Hospital level', child: HospitalForm()))
                  // MaterialPageRoute(builder: (context) => const CodePage(title: 'Fields', child: FormOne(selectedInstitution: "selectedInstitution",selectedLocation: "selectedLocation",)))
                );
              }
              } else if(selectedInstitution == "LSGD"){
                if (_formKey.currentState?.saveAndValidate() ?? false) {
                debugPrint(_formKey.currentState?.instantValue.toString() ?? '');
                Navigator.push(
                  context,

                  
                  MaterialPageRoute(builder: (context) => const ComingSoonPage())
                  
                  // MaterialPageRoute(builder: (context) => const ObjectDataTable(columnNames: ["sdfyighl","sfluig","eroiyg"], rowData: [[sdj,sdj,sdj]], constraint: BoxConstraints.expand(),))
                  // MaterialPageRoute(builder: (context) => const CodePage(title: 'Fields', child: FormOne(selectedInstitution: "selectedInstitution",selectedLocation: "selectedLocation",)))
                );
              }
              }
              
            },
          ),
        ],
      ),
    );
  }
}
