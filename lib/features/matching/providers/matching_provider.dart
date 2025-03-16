import 'package:flutter/material.dart';
import '../models/match_criteria.dart';
import '../models/match_result.dart';
import '../repositories/matching_repository.dart';

class MatchingProvider extends ChangeNotifier {
  final MatchingRepository _repository;
  
  MatchCriteria _criteria = MatchCriteria();
  List<MatchResult> _matches = [];
  bool _isLoading = false;
  String? _error;
  int _currentMatchIndex = 0;

  MatchingProvider({required MatchingRepository repository}) 
      : _repository = repository {
    _loadSavedCriteria();
    _fetchMatches();
  }

  // Getters
  MatchCriteria get criteria => _criteria;
  List<MatchResult> get matches => _matches;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentMatchIndex => _currentMatchIndex;
  MatchResult? get currentMatch => 
      _matches.isNotEmpty && _currentMatchIndex < _matches.length 
          ? _matches[_currentMatchIndex] 
          : null;
  bool get hasMatches => _matches.isNotEmpty;

  // Load saved criteria
  Future<void> _loadSavedCriteria() async {
    try {
      _criteria = await _repository.getMatchCriteria();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load saved criteria: $e';
      notifyListeners();
    }
  }

  // Fetch matches based on criteria
  Future<void> _fetchMatches() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _matches = await _repository.getMatches(_criteria);
      _currentMatchIndex = 0;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to fetch matches: $e';
      notifyListeners();
    }
  }

  // Update criteria and fetch new matches
  Future<void> updateCriteria(MatchCriteria newCriteria) async {
    _criteria = newCriteria;
    await _repository.saveMatchCriteria(newCriteria);
    await _fetchMatches();
  }

  // Move to next match
  void nextMatch() {
    if (_currentMatchIndex < _matches.length - 1) {
      _currentMatchIndex++;
      notifyListeners();
    } else if (_matches.isNotEmpty) {
      // Reached the end, fetch more matches
      _fetchMatches();
    }
  }

  // Move to previous match
  void previousMatch() {
    if (_currentMatchIndex > 0) {
      _currentMatchIndex--;
      notifyListeners();
    }
  }

  // Like current profile
  Future<void> likeCurrentProfile() async {
    if (currentMatch != null) {
      await _repository.likeProfile(currentMatch!.id);
      nextMatch();
    }
  }

  // Dislike current profile
  Future<void> dislikeCurrentProfile() async {
    if (currentMatch != null) {
      await _repository.dislikeProfile(currentMatch!.id);
      nextMatch();
    }
  }

  // Super like current profile
  Future<void> superLikeCurrentProfile() async {
    if (currentMatch != null) {
      await _repository.superLikeProfile(currentMatch!.id);
      nextMatch();
    }
  }

  // Refresh matches
  Future<void> refreshMatches() async {
    await _fetchMatches();
  }
}
