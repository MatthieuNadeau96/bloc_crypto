import 'package:bloc_crypto/models/coin_model.dart';
import 'package:bloc_crypto/repositories/crypto_repository.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _cryptoRepository = CryptoRepository();
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Coins'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              themeData.primaryColor,
              Colors.grey[900],
            ],
          ),
        ),
        child: FutureBuilder(
          future: _cryptoRepository.getTopCoins(page: _page),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(themeData.accentColor),
                ),
              );
            }
            final List<Coin> coins = snapshot.data;
            return RefreshIndicator(
              color: themeData.accentColor,
              onRefresh: () async {
                setState(() => _page = 0);
              },
              child: ListView.builder(
                itemCount: coins.length,
                itemBuilder: (BuildContext context, int index) {
                  final coin = coins[index];
                  return ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${++index}',
                          style: TextStyle(
                            color: themeData.accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                      coin.fullName,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      coin.name,
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                    trailing: Text(
                      '\$${coin.price.toStringAsFixed(4)}',
                      style: TextStyle(
                        color: themeData.accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
