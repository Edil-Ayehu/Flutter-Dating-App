import 'package:flutter/material.dart';
import '../models/icebreaker.dart';
import '../repositories/icebreaker_repository.dart';

class IcebreakerProvider extends ChangeNotifier {
  final IcebreakerRepository _repository;
  
  List<Icebreaker> _icebreakers = [];
  Map<String, List<IcebreakerAnswer>> _userAnswers = {};
  Map<String, List<IcebreakerAnswer>> _matchAnswers = {};
  bool _isLoading = false;
  String? _error;
  
  IcebreakerProvider({required IcebreakerRepository repository}) 
      : _repository = repository {
    _loadIcebreakers();
  }
  
  // Getters
  List<Icebreaker> get icebreakers => _icebreakers;
  Map<String, List<IcebreakerAnswer>> get userAnswers => _userAnswers;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> _loadIcebreakers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _icebreakers = await _repository.getIcebreakers();
      _userAnswers = await _repository.getUserAnswers();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
  
  Future<void> saveAnswer(String icebreakerID, String answer, {bool isPublic = true}) async {
    try {
      await _repository.saveAnswer(icebreakerID, answer, isPublic: isPublic);
      
      // Update local state
      if (_userAnswers.containsKey(icebreakerID)) {
        _userAnswers[icebreakerID]!.add(
          IcebreakerAnswer(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            icebreakerID: icebreakerID,
            userId: 'current_user',
            answer: answer,
            createdAt: DateTime.now(),
            isPublic: isPublic,
          ),
        );
      } else {
        _userAnswers[icebreakerID] = [
          IcebreakerAnswer(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            icebreakerID: icebreakerID,
            userId: 'current_user',
            answer: answer,
            createdAt: DateTime.now(),
            isPublic: isPublic,
          ),
        ];
      }
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
  
  List<Icebreaker> getUnansweredIcebreakers() {
    return _icebreakers.where((icebreaker) => 
      !_userAnswers.containsKey(icebreaker.id) || 
      _userAnswers[icebreaker.id]!.isEmpty
    ).toList();
  }
  
  List<Icebreaker> getAnsweredIcebreakers() {
    return _icebreakers.where((icebreaker) => 
      _userAnswers.containsKey(icebreaker.id) && 
      _userAnswers[icebreaker.id]!.isNotEmpty
    ).toList();
  }
  
  Future<void> loadMatchAnswers(String matchId) async {
    try {
      final answers = await _repository.getMatchAnswers(matchId);
      
      // Group answers by icebreaker ID
      _matchAnswers = {};
      for (var answer in answers) {
        if (_matchAnswers.containsKey(answer.icebreakerID)) {
          _matchAnswers[answer.icebreakerID]!.add(answer);
        } else {
          _matchAnswers[answer.icebreakerID] = [answer];
        }
      }
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
  
  List<IcebreakerAnswer> getMatchAnswersForIcebreaker(String icebreakerID) {
    return _matchAnswers[icebreakerID] ?? [];
  }
  
  Future<Icebreaker?> getSuggestedIcebreaker(String matchId) async {
    try {
      return await _repository.getSuggestedIcebreaker(matchId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
