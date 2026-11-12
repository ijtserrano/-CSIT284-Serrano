import 'package:quiz_app/models/quiz_question.dart';

const questions = [
  QuizQuestion(
    'What are the main building blocks of Flutter UIs?',
    [
      'Widgets',
      'Components',
      'Blocks',
      'Functions',
    ],
  ),
  QuizQuestion(
    'How is Flutter\'s UI programming paradigm best described?',
    [
      'Declarative',
      'Imperative',
      'Object-oriented',
      'Functional',
    ],
  ),
  QuizQuestion(
    'What\'s the purpose of a StatefulWidget?',
    [
      'Update UI as data changes',
      'Render UI that does not depend on data',
      'Ignore data changes',
      'Update data as UI changes',
    ],
  ),
  QuizQuestion(
    'Which widget should you try to use more often: StatelessWidget or StatefulWidget?',
    [
      'StatelessWidget',
      'StatefulWidget',
      'None of the above',
      'It does not matter',
    ],
  ),
  QuizQuestion(
    'What happens if you change data in a StatelessWidget?',
    [
      'The UI is not updated',
      'The UI is updated automatically',
      'The app crashes',
      'A new widget is created automatically',
    ],
  ),
  QuizQuestion(
    'How should you update data inside of StatefulWidgets?',
    [
      'By calling setState()',
      'By directly changing the data',
      'By restarting the app',
      'You cannot update data in StatefulWidgets',
    ],
  ),
];
