import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_buddy/gloabal.dart';
import 'package:study_buddy/packages/firebase_driver.dart';

/*
 * A model for Book 
 * fetches all data from db
 */
class Book {
  String _name;
  List<String> _chapters = [];
  Map<String, String> _curr_chapter = {
    "thischapterdata": "",
    "thischapter": "",
    "thischapterid": ""
  };
  Book(this._name);
  Future<List<String>> getContent() async {
    if (gUser != null) {
      _chapters = await getDoc('${gUser!.uid}/books/$_name', 'title');
    } else {
      _chapters = await getDoc(_name, 'title');
    }
    return _chapters;
  }

  String getCurrChapter() {
    return _curr_chapter["thischapterdata"]!;
  }

  String getCurrBook() {
    return _name;
  }

  String getCurrChapterTitle() {
    return _curr_chapter["thischapter"]!;
  }

  bool isChapterPresent(String ch) {
    return _chapters.contains(ch);
  }

  Future<String> getChapter(String ch) async {
    if (_curr_chapter["thischapter"] != ch) {
      _curr_chapter["thischapter"] = ch;
      if (gUser != null) {
        await FirebaseFirestore.instance
            .collection('${gUser!.uid}/books/$_name')
            .where('title', isEqualTo: ch)
            .get()
            .then((value) {
          _curr_chapter["thischapterdata"] = value.docs[0].data()['content'];
          _curr_chapter["thischapterid"] = value.docs[0].id;
        });
      } else {
        await FirebaseFirestore.instance
            .collection(_name)
            .where('title', isEqualTo: ch)
            .get()
            .then((value) {
          _curr_chapter["thischapterdata"] = value.docs[0].data()['content'];
          _curr_chapter["thischapterid"] = value.docs[0].id;
        });
      }
    }
    return _curr_chapter["thischapterdata"]!;
  }

  Future<void> updateChapter(String newdata) async {
    await FirebaseFirestore.instance
        .collection('${gUser!.uid}/books/$_name')
        .doc(_curr_chapter["thischapterid"])
        .update({
      'content': newdata,
    });
    _curr_chapter["thischapterdata"] = newdata;
  }

  Future<void> createChapter(String name) async {
    if (name != "" && !isChapterPresent(name)) {
      await FirebaseFirestore.instance
          .collection('${gUser!.uid}/books/$_name')
          .add({
        'content': "<h1>$name</h1>" +
            r"$$a^2$$ $$x={-b \pm \sqrt{b^2-4ac}\over 2a}$$ \(ax^{12}+bz+c\) <li> \(\alpha \Alpha \epsilon \Epsilon \Beta \Tau \beta\) </li>",
        'title': name
      }).then((_) => _chapters.add(name));
    }
  }

  Future<void> deleteChapter(String name) async {
    await getContent();
    if (name != "" && isChapterPresent(name)) {
      await getChapter(name);
      await FirebaseFirestore.instance
          .collection('${gUser!.uid}/books/$_name')
          .doc(_curr_chapter['thischapterid'])
          .delete();
    }
    _chapters.remove(name);
  }
}
