import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/color_constants.dart';
import '../models/icebreaker.dart';
import '../providers/icebreaker_provider.dart';
import '../widgets/icebreaker_card.dart';


class IcebreakerListScreen extends StatefulWidget {
  const IcebreakerListScreen({Key? key}) : super(key: key);

  @override
  State<IcebreakerListScreen> createState() => _IcebreakerListScreenState();
}

class _IcebreakerListScreenState extends State<IcebreakerListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Icebreakers'),
        backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<IcebreakerProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading icebreakers',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      provider.clearError();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          final answeredIcebreakers = provider.getAnsweredIcebreakers();
          final unansweredIcebreakers = provider.getUnansweredIcebreakers();
          
          return Column(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                indicatorColor: AppColors.primary,
                tabs: const [
                  Tab(text: 'To Answer'),
                  Tab(text: 'Answered'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Unanswered icebreakers
                    unansweredIcebreakers.isEmpty
                        ? Center(
                            child: Text(
                              'No icebreakers to answer',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: unansweredIcebreakers.length,
                            itemBuilder: (context, index) {
                              final icebreaker = unansweredIcebreakers[index];
                              return IcebreakerCard(
                                icebreaker: icebreaker,
                                onTap: () => _navigateToIcebreakerDetail(context, icebreaker),
                              );
                            },
                          ),
                    
                    // Answered icebreakers
                    answeredIcebreakers.isEmpty
                        ? Center(
                            child: Text(
                              'You haven\'t answered any icebreakers yet',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: answeredIcebreakers.length,
                            itemBuilder: (context, index) {
                              final icebreaker = answeredIcebreakers[index];
                              final answers = provider.userAnswers[icebreaker.id] ?? [];
                              
                              return IcebreakerCard(
                                icebreaker: icebreaker,
                                answer: answers.isNotEmpty ? answers.first.answer : null,
                                onTap: () => _navigateToIcebreakerDetail(context, icebreaker),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  
  void _navigateToIcebreakerDetail(BuildContext context, Icebreaker icebreaker) {
    Navigator.pushNamed(
      context,
      '/icebreaker-detail',
      arguments: icebreaker,
    );
  }
}
