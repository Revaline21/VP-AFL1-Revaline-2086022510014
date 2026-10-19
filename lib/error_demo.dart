import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 320,
                  child: Row(
                    children: const [
                      Expanded(
                        child: Text(
                          'Ini adalah kalimat yang sangat panjang sekali sehingga tidak muat di lebar layar',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 30),
                  child: const Column(
                    children: [
                      Text('Baris pertama', style: TextStyle(fontSize: 24)),
                      Text('Baris kedua', style: TextStyle(fontSize: 24)),
                      Text('Baris ketiga', style: TextStyle(fontSize: 24)),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  height: 200,
                  child: ListView(
                    children: const [
                      Text('Baris 1', style: TextStyle(fontSize: 40)),
                      Text('Baris 2', style: TextStyle(fontSize: 40)),
                      Text('Baris 3', style: TextStyle(fontSize: 40)),
                      Text('Baris 4', style: TextStyle(fontSize: 40)),
                      Text('Baris 5', style: TextStyle(fontSize: 40)),
                      Text('Baris 6', style: TextStyle(fontSize: 40)),
                      Text('Baris 7', style: TextStyle(fontSize: 40)),
                      Text('Baris 8', style: TextStyle(fontSize: 40)),
                      ],
                    ),
                    ),
              ],
            ),
          ),
        ),
      ),
    ));
