import 'dart:async';
import 'dart:convert';

import 'package:bro_app_to/components/custom_dropdown.dart';
import 'package:bro_app_to/components/i_field.dart';
import 'package:bro_app_to/src/registration/presentation/screens/first_video.dart';
import 'package:bro_app_to/utils/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../components/custom_text_button.dart';
import '../../../../providers/player_provider.dart';
import '../../../../utils/current_state.dart';

class SignUpScreen2 extends StatefulWidget {
  const SignUpScreen2({super.key});

  @override
  State<SignUpScreen2> createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen2> {
  bool isLoading = false;
  bool _acceptedTerms = false;
  late TextEditingController clubController;
  late TextEditingController achivementController;

  String dominantFoot = translations!['left_feet'];
  String selection = translations!['male'];
  String catSelection = '12';
  String selectedCountry = 'Spain';
  String selectedProvince = '';
  String selectedHeight = '165cm';
  String selectedCategory = '12';

  Future<bool> validateForm(BuildContext context) async {
    if (selectedCountry.isEmpty ||
        selectedProvince.isEmpty ||
        clubController.text.isEmpty ||
        achivementController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(translations!['complete_all_fields'])),
      );
      return false;
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    clubController = TextEditingController();
    achivementController = TextEditingController();
  }

  @override
  void dispose() {
    clubController.dispose();
    achivementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 0, 0, 0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Positioned.fill(
            child: Image.asset(
              'assets/images/BackgroundRegis.png',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 145.0, 24, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  translations!['sign_up'],
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      translations!['country_label'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    DropdownWidget<String>(
                      value: selectedCountry,
                      items: const [
                        'Spain',
                        'United States',
                        'France',
                        'Italy',
                        'Germany'
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCountry = newValue!;

                          selectedProvince = '';
                        });
                      },
                      itemBuilder: (String item) {
                        return item;
                      },
                      width: 120,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      translations!['state_label'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    DropdownWidget<String>(
                      value: selectedProvince,
                      items: provincesByCountry[selectedCountry]!.toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedProvince = newValue!;
                        });
                      },
                      itemBuilder: (String item) {
                        return item;
                      },
                      width: 120,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      translations!['height_label'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    DropdownWidget<String>(
                      value: selectedHeight,
                      items: List.generate(
                          211 - 150, (index) => '${index + 150} cm'),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedHeight = newValue!;
                        });
                      },
                      itemBuilder: (String item) {
                        return item;
                      },
                      width: 120,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      translations!['category_label'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    DropdownWidget<String>(
                      value: selectedCategory,
                      items: const ['12', '13', '14', '15'],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue!;
                        });
                      },
                      itemBuilder: (String item) {
                        return item;
                      },
                      width: 120,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                iField(clubController, translations!['club_label']),
                const SizedBox(height: 10),
                iField(achivementController,
                    translations!['individual_achievements']),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      translations!['dominant_feet'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    DropdownWidget<String>(
                      value: dominantFoot,
                      items: [
                        translations!['left_feet'].toString(),
                        translations!['right_feet'].toString(),
                        translations!['both_feet'].toString(),
                      ].toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dominantFoot = newValue ?? translations!['left_feet'];
                        });
                      },
                      itemBuilder: (String item) {
                        return item;
                      },
                      width: 120,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      translations!['national_selection'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    DropdownWidget<String>(
                      value: selection,
                      items: [
                        translations!['male'].toString(),
                        translations!['female'].toString(),
                      ].toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selection = newValue ?? translations!['male'];
                        });
                      },
                      itemBuilder: (String item) {
                        return item;
                      },
                      width: 110,
                    ),
                    const SizedBox(width: 10),
                    DropdownWidget<String>(
                      value: catSelection,
                      items: ['12', '13', '14', '15', '16'].toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          catSelection = newValue ?? '12';
                        });
                      },
                      itemBuilder: (String item) {
                        return item;
                      },
                      width: 70,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: _acceptedTerms,
                      onChanged: (bool? value) {
                        setState(() {
                          _acceptedTerms = value!;
                        });
                      },
                      fillColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return const Color(0xff00E050);
                          }
                          return Colors.white;
                        },
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _acceptedTerms = !_acceptedTerms;
                          });
                        },
                        child: RichText(
                          text: TextSpan(
                            text: translations!['terms'],
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                            children: [
                              TextSpan(
                                text: translations!['terms2'],
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 55),
                CustomTextButton(
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      FocusScope.of(context).unfocus();

                      bool isValid = await validateForm(
                        context,
                      );
                      if (!_acceptedTerms) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.redAccent,
                            content: Text(
                              translations!['accept_terms'],
                            ),
                          ),
                        );
                        setState(() {
                          isLoading = false;
                        });
                        return;
                      }
                      if (isValid) {
                        final playerProvider =
                            Provider.of<PlayerProvider>(context, listen: false);
                        playerProvider.updateTemporalPlayer(
                          pais: selectedCountry,
                          provincia: selectedProvince,
                          categoria: selectedCategory,
                          club: clubController.text,
                          logros: achivementController.text,
                          altura: selectedHeight,
                          pieDominante: dominantFoot,
                          seleccion: selection,
                          categoriaSeleccion: catSelection,
                        );
                        try {
                          final response = await ApiClient().post(
                            'auth/player',
                            playerProvider.getTemporalUser().toMap(),
                          );

                          if (response.statusCode == 200) {
                            final jsonData = jsonDecode(response.body);
                            final userId = jsonData["userInfo"]["userId"];

                            playerProvider.updateTemporalPlayer(
                              userId: userId.toString(),
                            );

                            final name =
                                "${playerProvider.getTemporalUser().name} ${playerProvider.getTemporalUser().lastName}";
                            final email =
                                playerProvider.getTemporalUser().email;

                            final responseStripe = await ApiClient().post(
                              'security_filter/v1/api/payment/customer',
                              {
                                "userId": userId.toString(),
                                "CompleteName": name,
                                "Email": email
                              },
                            );
                            if (responseStripe.statusCode != 200) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.redAccent,
                                  content: Text(
                                      translations!['error_create_account']),
                                ),
                              );
                              return;
                            }
                            final jsonDataCus = jsonDecode(responseStripe.body);
                            final customerId = jsonDataCus["customerId"];
                            playerProvider.updateTemporalPlayer(
                                customerStripeId: customerId);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: const Color(0xFF05FF00),
                                content:
                                    Text(translations!['scss_create_account']),
                              ),
                            );
                            await Future.delayed(const Duration(seconds: 2));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FirstVideoWidget()),
                            );
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            final jsonData = json.decode(response.body);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  backgroundColor: Colors.redAccent,
                                  content: Text(jsonData["error"])),
                            );
                          }
                        } on TimeoutException {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text(translations!['error_try_again']),
                            ),
                          );
                          setState(() {
                            isLoading = false;
                          });
                          return;
                        }
                      }
                    },
                    text: translations!['next'],
                    buttonPrimary: true,
                    width: 116,
                    height: 39),
                const SizedBox(height: 85),
                SvgPicture.asset(
                  width: 104,
                  'assets/icons/Logo.svg',
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF05FF00)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Map<String, List<String>> provincesByCountry = {
    'Spain': [
      'A Coruña',
      'Álava',
      'Albacete',
      'Alicante',
      'Almería',
      'Asturias',
      'Ávila',
      'Badajoz',
      'Baleares',
      'Barcelona',
      'Burgos',
      'Cáceres',
      'Cádiz',
      'Cantabria',
      'Castellón',
      'Ceuta',
      'Ciudad Real',
      'Córdoba',
      'Cuenca',
      'Girona',
      'Granada',
      'Guadalajara',
      'Gipuzkoa',
      'Huelva',
      'Huesca',
      'Jaén',
      'La Rioja',
      'Las Palmas',
      'León',
      'Lleida',
      'Lugo',
      'Madrid',
      'Málaga',
      'Melilla',
      'Murcia',
      'Navarra',
      'Ourense',
      'Palencia',
      'Pontevedra',
      'Salamanca',
      'Segovia',
      'Sevilla',
      'Soria',
      'Tarragona',
      'Santa Cruz de Tenerife',
      'Teruel',
      'Toledo',
      'Valencia',
      'Valladolid',
      'Vizcaya',
      'Zamora',
      'Zaragoza'
    ],
    'United States': [
      'Alabama',
      'Alaska',
      'Arizona',
      'Arkansas',
      'California',
      'Colorado',
      'Connecticut',
      'Delaware',
      'District of Columbia',
      'Florida',
      'Georgia',
      'Hawaii',
      'Idaho',
      'Illinois',
      'Indiana',
      'Iowa',
      'Kansas',
      'Kentucky',
      'Louisiana',
      'Maine',
      'Maryland',
      'Massachusetts',
      'Michigan',
      'Minnesota',
      'Mississippi',
      'Missouri',
      'Montana',
      'Nebraska',
      'Nevada',
      'New Hampshire',
      'New Jersey',
      'New Mexico',
      'New York',
      'North Carolina',
      'North Dakota',
      'Ohio',
      'Oklahoma',
      'Oregon',
      'Pennsylvania',
      'Rhode Island',
      'South Carolina',
      'South Dakota',
      'Tennessee',
      'Texas',
      'Utah',
      'Vermont',
      'Virginia',
      'Washington',
      'West Virginia',
      'Wisconsin',
      'Wyoming'
    ],
    'France': [
      'Ain',
      'Aisne',
      'Allier',
      'Alpes-de-Haute-Provence',
      'Hautes-Alpes',
      'Alpes-Maritimes',
      'Ardèche',
      'Ardennes',
      'Ariège',
      'Aube',
      'Aude',
      'Aveyron',
      'Bouches-du-Rhône',
      'Calvados',
      'Cantal',
      'Charente',
      'Charente-Maritime',
      'Cher',
      'Corrèze',
      'Côte-d\'Or',
      'Côtes-d\'Armor',
      'Creuse',
      'Dordogne',
      'Doubs',
      'Drôme',
      'Eure',
      'Eure-et-Loir',
      'Finistère',
      'Corse-du-Sud',
      'Haute-Corse',
      'Gard',
      'Haute-Garonne',
      'Gers',
      'Gironde',
      'Hérault',
      'Ille-et-Vilaine',
      'Indre',
      'Indre-et-Loire',
      'Isère',
      'Jura',
      'Landes',
      'Loir-et-Cher',
      'Loire',
      'Haute-Loire',
      'Loire-Atlantique',
      'Loiret',
      'Lot',
      'Lot-et-Garonne',
      'Lozère',
      'Maine-et-Loire',
      'Manche',
      'Marne',
      'Haute-Marne',
      'Mayenne',
      'Meurthe-et-Moselle',
      'Meuse',
      'Morbihan',
      'Moselle',
      'Nièvre',
      'Nord',
      'Oise',
      'Orne',
      'Pas-de-Calais',
      'Puy-de-Dôme',
      'Pyrénées-Atlantiques',
      'Hautes-Pyrénées',
      'Pyrénées-Orientales',
      'Bas-Rhin',
      'Haut-Rhin',
      'Rhône',
      'Haute-Saône',
      'Saône-et-Loire',
      'Sarthe',
      'Savoie',
      'Haute-Savoie',
      'Paris',
      'Seine-Maritime',
      'Seine-et-Marne',
      'Yvelines',
      'Deux-Sèvres',
      'Somme',
      'Tarn',
      'Tarn-et-Garonne',
      'Var',
      'Vaucluse',
      'Vendée',
      'Vienne',
      'Haute-Vienne',
      'Vosges',
      'Yonne',
      'Territoire de Belfort',
      'Essonne',
      'Hauts-de-Seine',
      'Seine-Saint-Denis',
      'Val-de-Marne',
      'Val-d\'Oise'
    ],
    'Italy': [
      'Agrigento',
      'Alessandria',
      'Ancona',
      'Aosta',
      'Arezzo',
      'Ascoli Piceno',
      'Asti',
      'Avellino',
      'Bari',
      'Barletta-Andria-Trani',
      'Belluno',
      'Benevento',
      'Bergamo',
      'Biella',
      'Bologna',
      'Bolzano',
      'Brescia',
      'Brindisi',
      'Cagliari',
      'Caltanissetta',
      'Campobasso',
      'Carbonia-Iglesias',
      'Caserta',
      'Catania',
      'Catanzaro',
      'Chieti',
      'Como',
      'Cosenza',
      'Cremona',
      'Crotone',
      'Cuneo',
      'Enna',
      'Fermo',
      'Ferrara',
      'Firenze',
      'Foggia',
      'Forlì-Cesena',
      'Frosinone',
      'Genova',
      'Gorizia',
      'Grosseto',
      'Imperia',
      'Isernia',
      'La Spezia',
      'L\'Aquila',
      'Latina',
      'Lecce',
      'Lecco',
      'Livorno',
      'Lodi',
      'Lucca',
      'Macerata',
      'Mantova',
      'Massa-Carrara',
      'Matera',
      'Medio Campidano',
      'Messina',
      'Milano',
      'Modena',
      'Monza e della Brianza',
      'Napoli',
      'Novara',
      'Nuoro',
      'Ogliastra',
      'Olbia-Tempio',
      'Oristano',
      'Padova',
      'Palermo',
      'Parma',
      'Pavia',
      'Perugia',
      'Pesaro e Urbino',
      'Pescara',
      'Piacenza',
      'Pisa',
      'Pistoia',
      'Pordenone',
      'Potenza',
      'Prato',
      'Ragusa',
      'Ravenna',
      'Reggio Calabria',
      'Reggio Emilia',
      'Rieti',
      'Rimini',
      'Roma',
      'Rovigo',
      'Salerno',
      'Sassari',
      'Savona',
      'Siena',
      'Siracusa',
      'Sondrio',
      'Taranto',
      'Teramo',
      'Terni',
      'Torino',
      'Trapani',
      'Trento',
      'Treviso',
      'Trieste',
      'Udine',
      'Varese',
      'Venezia',
      'Verbano-Cusio-Ossola',
      'Vercelli',
      'Verona',
      'Vibo Valentia',
      'Vicenza',
      'Viterbo'
    ],
    'Germany': [
      'Baden-Württemberg',
      'Bavaria',
      'Berlin',
      'Brandenburg',
      'Bremen',
      'Hamburg',
      'Hesse',
      'Lower Saxony',
      'Mecklenburg-Vorpommern',
      'North Rhine-Westphalia',
      'Rhineland-Palatinate',
      'Saarland',
      'Saxony',
      'Saxony-Anhalt',
      'Schleswig-Holstein',
      'Thuringia'
    ],
  };
}
