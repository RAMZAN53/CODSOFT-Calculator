import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main()
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.transparent,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ' Calculator'),
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
  String userInput = "";
  String result = "0";
  List<String> buttonList =
  [
    "AC", "(", ")", "C",
    "7", "8", "9", "*",
    "4", "5", "6", "+",
    "1", "2", "3", "-",
    "0", ".", "/", "=",
  ];
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children:
          [
            Container(
              height: MediaQuery.of(context).size.height / 7,
              child: resultWidget(),
            ),
            Container(
              color: Colors.cyan,
              height:40,
            ),
            Expanded(child: buttonWidget()),
            Container(
              height:50,
              color: Colors.cyan,
              child: Center(
                child: Column(
                  children:
                  [
                    Text(
                        '>>RAMZAN<<',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.indigo,
                        ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blueGrey,
    );
  }

  Widget resultWidget()
  {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        border: Border.all(
          color: Colors.black,
          width: 7,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      // color: Colors.grey,
      padding: const EdgeInsets.all(30),
      alignment: Alignment.centerRight,
      child: Text(
        userInput,
        style: const TextStyle(
          fontSize: 24,
          fontWeight:FontWeight.bold,
        ),
      ),
    );
  }

  Widget buttonWidget()
  {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        border: Border.all(
          color: Colors.black,
          width: 7,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: const EdgeInsets.all(10),
      // color: Colors.transparent,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index)
        {
          return button(buttonList[index]);
        },
        itemCount: buttonList.length,
      ),
    );
  }

  Color getColor(String text)
  {
    if (text == "/" || text == "*" || text == "+" || text == "-" || text == "C" || text == "(" || text == ")") {
      return Colors.redAccent;
    }
    if (text == "=" || text == "AC")
    {
      return Colors.white;
    }
    return Colors.white;
  }

  Color getBgColor(String text)
  {
    if (text == "AC")
    {
      return Colors.red;
    }
    if (text == "=")
    {
      return Colors.redAccent;
    }
    return Colors.transparent;
  }

  Widget button(String text)
  {
    return InkWell(
      onTap: ()
      {
        setState(()
        {
          ButtonPress(text);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: getBgColor(text),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.black,
            width: 4,
          ),
          boxShadow: const
          [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 1,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: getColor(text),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
  void ButtonPress(String text)
  {
    if (text == "AC")
    {
      userInput = "";
      result = "0";
    }
    else if (text == "C")
    {
      userInput = userInput.substring(0, userInput.length - 1);
    }
    else if (text == "=")
    {
      result = Calculation();
      userInput = result;
      if (userInput.endsWith(".0"))
      {
        userInput = userInput.replaceAll(".0", "");
      }
      if (result.endsWith(".0"))
      {
        result = result.replaceAll(".0", "");
      }
    }
    else
    {
      userInput += text;
    }
  }
  String Calculation()
  {
    try
    {
      final expression = Parser().parse(userInput);
      final evaluation = expression.evaluate(EvaluationType.REAL, ContextModel());
      return evaluation.toString();
    }
    catch (e)
    {
      return "INVALID INPUT BY USER";
    }
  }
}