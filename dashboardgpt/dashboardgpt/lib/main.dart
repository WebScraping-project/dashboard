import 'package:flutter/material.dart';
import 'liste_attractions.dart';
import 'attraction.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        cardColor: Colors.white,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Attraction> attractions;
  List<Attraction> filteredAttractions = [];

  List<Attraction> topAttractions = [];

  String selectedView = 'Disneyland';

  @override
  void initState() {
    super.initState();
    _loadAttractions();
  }

  Future<void> _loadAttractions() async {
    attractions = await parseAttractions();
    filteredAttractions = List.from(attractions);

    // Mettre à jour le top 3 des attractions
    _updateTopAttractions();
    disneylandAttractions = await parseAttractions();
    studioAttractions = await parseStudioAttractions();

    // Initialiser filteredAttractions avec les attractions de Disneyland par défaut
    filteredAttractions = List.from(disneylandAttractions);

    setState(() {});
  }

  void _updateTopAttractions() {
    attractions.sort((a, b) => b.waitTime.compareTo(a.waitTime));
    topAttractions = attractions.take(3).toList();
  }

  void _onViewChanged(String? view) {
    setState(() {
      selectedView = view ?? 'Disneyland';

      if (view == 'Disneyland') {

        selectedView = view ?? 'Disneyland';
        if (view == 'Disneyland') {
          selectedView = view ?? 'Disneyland';
          if (view == 'Disneyland') {
            filteredAttractions = List.from(attractions);
          } else {
            filteredAttractions = attractions
                .where((attraction) => attraction.secteur == view)
                .toList();
          }

          // Mettre à jour le top 3 des attractions lors du changement de vue
          _updateTopAttractions();
        }
      if (view == 'Disneyland') {
        filteredAttractions = List.from(attractions);
      } else {
        filteredAttractions = attractions
            .where((attraction) => attraction.secteur == view)
            .toList();




      }

      // Mettre à jour le top 3 des attractions lors du changement de vue
      _updateTopAttractions();
    });
  }

  Widget buildTopAttractionsContainer() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        constraints: const BoxConstraints(
          maxHeight: double.infinity,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top 3 Attractions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 10.0),
            for (var attraction in topAttractions)
              ListTile(
                title: Text(attraction.name),
                subtitle: Text(
                  'Temps d\'attente: ${attraction.waitTime} minutes',
                ),
                trailing: Icon(
                  attraction.isAvailable ? Icons.check_circle : Icons.cancel,
                  color: attraction.isAvailable ? Colors.green : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildAttractionsInfoContainer() {
    int totalAttractions = attractions.length;
    int availableAttractions =
        attractions.where((attraction) => attraction.isAvailable).length;

    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          '$availableAttractions / $totalAttractions Attractions disponibles',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [Colors.blue, Colors.green],
            ).createShader(bounds);
          },
          child: Center(
            child: Text(
              'Disneyline Tracker',
              style: GoogleFonts.happyMonkey(
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Couleur du texte
              ),
            ),
          ),
        ),
      ),

      backgroundColor: Colors.white, // Ajout de la couleur de fond blanche
      body: Row(
        children: [
          // Partie gauche avec la liste des attractions
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: disneylandAttractions == null
                  ? const CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              'Trier les attractions',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                gradient: const LinearGradient(
                                  colors: [Colors.blue, Colors.green],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                              child: Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 300),
                                child: PopupMenuButton<String>(
                                  icon: const Icon(
                                    Icons.sort,
                                    color: Colors.white,
                                  ),
                                  onSelected: _onViewChanged,
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      'Disneyland',
                                      'Main Street U.S.A',
                                      'Frontierland',
                                      'Adventureland',
                                      'Fantasyland',
                                      'Discoveryland',
                                    ].map((String view) {
                                      return PopupMenuItem<String>(
                                        value: view,
                                        child: Center(
                                          child: Text(
                                            view,
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList();
                                  },
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Disneyland',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Colors.black,
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  initialValue: selectedView,
                                  onSelected: _onViewChanged,
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      'Toutes les attractions',
                                      'Main Street U.S.A',
                                      'Frontierland',
                                      'Adventureland',
                                      'Fantasyland',
                                      'Discoveryland',
                                    ].map((String view) {
                                      return PopupMenuItem<String>(
                                        value: view,
                                        child: Text(view),
                                      );
                                    }).toList();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Icon(Icons.arrow_drop_down),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Expanded(
                              child: Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 600),
                                child: ListView.builder(
                                  itemCount: filteredAttractions.length,
                                  itemBuilder: (context, index) {
                                    var attraction = filteredAttractions[index];
                                    return Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        elevation: 5,
                                        color: Colors
                                            .white, // Couleur de fond blanche
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 16.0,
                                          ),
                                          leading: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Image.asset(
                                              attraction.photoUrl,
                                              width: 56,
                                              height: 56,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          title: Text(attraction.name),
                                          subtitle: Text(
                                            'Temps d\'attente: ${attraction.waitTime} minutes',
                                          ),
                                          trailing: Icon(
                                            attraction.isAvailable
                                                ? Icons.check_circle
                                                : Icons.cancel,
                                            color: attraction.isAvailable
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],

      body: Center(
        child: attractions == null
            ? CircularProgressIndicator()
            : Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 200, // Ajuster la largeur selon votre besoin
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: const LinearGradient(
                            colors: [Colors.blue, Colors.green],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        child: DropdownButton<String>(
                          value: selectedView,
                          onChanged: _onViewChanged,
                          isExpanded: true,
                          elevation: 5,
                          items: [
                            'Disneyland',
                            'Main Street U.S.A',
                            'Frontierland',
                            'Adventureland',
                            'Fantasyland',
                            'Discoveryland'
                          ].map((String view) {
                            return DropdownMenuItem<String>(
                              value: view,
                              child: Center(
                                child: Text(
                                  view,
                                  style: GoogleFonts.roboto(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          // Utilisez icon pour appliquer un style personnalisé
                          underline:
                              Container(), // Ajoutez cette ligne pour éviter l'erreur
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Expanded(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 600),
                        child: ListView.builder(
                          itemCount: filteredAttractions.length,
                          itemBuilder: (context, index) {
                            var attraction = filteredAttractions[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(255, 158, 158, 158)
                                        .withOpacity(0.2),
                                    spreadRadius: 0.1,
                                    blurRadius: 0,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.asset(
                                    attraction.photoUrl,
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(attraction.name),
                                subtitle: Text(
                                  'Temps d\'attente: ${attraction.waitTime} minutes',
                                ),
                                trailing: Icon(
                                  attraction.isAvailable
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: attraction.isAvailable
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            );
                          },

                        ),
                      ),
                    ),
            ),
          ),
          // Partie droite avec le top 3 des attractions et les informations sur les attractions
          SizedBox(
            width: 400.0, // Ajustez la largeur selon vos besoins
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                buildAttractionsInfoContainer(),
                const SizedBox(height: 16.0),
                buildTopAttractionsContainer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}