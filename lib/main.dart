import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Quiz App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Icon> _scoreTracker = [];
  int _questionIndex = 0;
  int _totalScore = 0;
  bool answerSelected = false;
  bool endOfQuiz = false;
  bool correctAnswerSelected = false;

  void _answered(bool answerScore) {
    setState(() {
      answerSelected = true;
      if(answerScore) {
        _totalScore += 1;
        correctAnswerSelected = true;
      }
      _scoreTracker.add(
        answerScore ?
            const Icon(
              Icons.check_circle,
                  color: Colors.green,
            )
            : const Icon(
          Icons.clear,
          color: Colors.red,
        )
      );
      if(_questionIndex + 1 == _questions.length) {
        endOfQuiz = true;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _questionIndex += 1;
      answerSelected = false;
      correctAnswerSelected = false;
    });

    if(_questionIndex >= _questions.length) {
      _resetQuiz();
    }
  }

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
      _scoreTracker = [];
      endOfQuiz = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Row(
              children: [
                if(_scoreTracker.isEmpty)
                  const SizedBox(height: 25.0,),
                if(_scoreTracker.isNotEmpty)
                  ..._scoreTracker
              ],
            ),
            Container(
              width: double.infinity,
              height: 150.0,
              margin: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 10.0),
              padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  _questions[_questionIndex]['question'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ...(_questions[_questionIndex]['answers']
            as List<Map<String, Object>>).map((answer) => Answer(
                  answerText: answer['answerText'] as String,
              answerColor: answerSelected ?
              (answer['score'] as bool) ? Colors.green : Colors.red
              : Colors.white,
              answerTap: () {
                    if(answerSelected) {
                      return;
                    }
                    _answered(answer['score'] as bool);
              },
            ),
            ),
            SizedBox(height: 30.0,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200.0, 40.0),
              ),
                onPressed: () {
                  if(!answerSelected) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        'Please select an answer',
                      ),
                    ));
                    return;
                  }
                  _nextQuestion();
                },
                child: Text(endOfQuiz ? 'Restart Quiz' : 'Next question'),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                '${_totalScore.toString()}/${_questions.length}',
                style: const TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if(answerSelected && !endOfQuiz)
              Container(
                height: 50,
                width: double.infinity,
                color: correctAnswerSelected ? Colors.green : Colors.red,
                child: Center(
                  child: Text(
                    correctAnswerSelected ? 'Right. Well done!'
                        : 'Oops. Wrong answer!',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            if(endOfQuiz)
              Container(
                height: 50,
                width: double.infinity,
                color: Colors.deepPurple,
                child: Center(
                  child: Text(
                    _totalScore > 2 ? 'Congratulations! Your final score is: $_totalScore'
                        : 'Your final score is: $_totalScore. Better luck next time.',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: _totalScore > 2 ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class Answer extends StatelessWidget {
  final String answerText;
  final Color answerColor;
  final Function answerTap;

  Answer({required this.answerText, required this.answerColor, required this.answerTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        answerTap();
      },
      child: Container(
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: answerColor,
          border: Border.all(color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          answerText,
          style: const TextStyle(
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }
}


const _questions = [
  {
    'question': 'Who wrote The Old Man and The Sea?',
    'answers': [
      {'answerText': 'George Orwell', 'score': false},
      {'answerText': 'Ernest Hemingway', 'score': true},
      {'answerText': 'F. Scott Fitzgerald', 'score': false},
      {'answerText': 'Fyodor Dostoevsky', 'score': false},
    ],
  },
  {
    'question': 'What spell did Harry use to fight Voldemort??',
    'answers': [
      {'answerText': 'Expecto Patronum', 'score': false},
      {'answerText': 'Avada Kedavra', 'score': false},
      {'answerText': 'Accio', 'score': false},
      {'answerText': 'Expelliarmus', 'score': true},
    ],
  },
  {
    'question': 'A poor life this if, full of care... We have no time to stand and stare - which poem is this line from?',
    'answers': [
      {'answerText': 'Stopping by Woods on a Snowy Evening', 'score': false},
      {'answerText': 'I Wandered Lonely as a Cloud', 'score': false},
      {'answerText': 'Sonnet 18', 'score': false},
      {'answerText': 'Leisure', 'score': true},
    ],
  },
  {
    'question': 'Which club has won the most Champions League trophies?',
    'answers': [
      {'answerText': 'Real Madrid', 'score': true},
      {'answerText': 'FC Barcelona', 'score': false},
      {'answerText': 'Bayern Munich', 'score': false},
      {'answerText': 'AC Milan', 'score': false},
    ],
  },
  {
    'question': 'Which player has scored the most goals in the World Cup?',
    'answers': [
      {'answerText': 'Cristiano Ronaldo', 'score': false},
      {'answerText': 'Lionel Messi', 'score': false},
      {'answerText': 'Miroslav Klose', 'score': true},
      {'answerText': 'Ronaldo Nazário', 'score': false},
    ],
  },
];