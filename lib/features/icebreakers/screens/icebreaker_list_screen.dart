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
    _tabController.addListener(() {
      setState(() {}); // Rebuild when tab changes to update UI
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Icebreakers'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: theme.appBarTheme.elevation,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<IcebreakerProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            );
          }
          
          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading icebreakers',
                    style: theme.textTheme.bodyLarge,
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
              // Custom styled tab bar
              Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                height: 48,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Material(
                  color: Colors.transparent,
                  elevation: 0,
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: theme.colorScheme.primary,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 0,
                    indicatorPadding: EdgeInsets.zero,
                    dividerColor: Colors.transparent,
                    labelColor: Colors.white,
                    unselectedLabelColor: isDarkMode ? Colors.white70 : Colors.black54,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.question_answer_outlined,
                              size: 16,
                              color: _tabController.index == 0 
                                  ? Colors.white 
                                  : (isDarkMode ? Colors.white70 : Colors.black54),
                            ),
                            const SizedBox(width: 6),
                            const Text('To Answer'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 16,
                              color: _tabController.index == 1 
                                  ? Colors.white 
                                  : (isDarkMode ? Colors.white70 : Colors.black54),
                            ),
                            const SizedBox(width: 6),
                            const Text('Answered'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Unanswered icebreakers
                    AnimatedOpacity(
                      opacity: _tabController.index == 0 ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 250),
                      child: unansweredIcebreakers.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.question_answer_outlined,
                                    size: 64,
                                    color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No icebreakers to answer',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
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
                    ),
                    
                    // Answered icebreakers
                    AnimatedOpacity(
                      opacity: _tabController.index == 1 ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 250),
                      child: answeredIcebreakers.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: 64,
                                    color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'You haven\'t answered any icebreakers yet',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
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
