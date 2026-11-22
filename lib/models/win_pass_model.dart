class WinPassStepModel {
  final int id;
  final int stepNumber;
  final String rewardType;
  final String? rewardValue;
  final String titleAr;
  final String titleEn;
  final String? descriptionAr;
  final String? descriptionEn;

  WinPassStepModel({
    required this.id,
    required this.stepNumber,
    required this.rewardType,
    this.rewardValue,
    required this.titleAr,
    required this.titleEn,
    this.descriptionAr,
    this.descriptionEn,
  });

  factory WinPassStepModel.fromJson(Map<String, dynamic> json) {
    return WinPassStepModel(
      id: json['id'] ?? 0,
      stepNumber: json['step_number'] ?? 0,
      rewardType: json['reward_type'] ?? 'none',
      rewardValue: json['reward_value']?.toString(),
      titleAr: json['title_ar'] ?? '',
      titleEn: json['title_en'] ?? '',
      descriptionAr: json['description_ar'],
      descriptionEn: json['description_en'],
    );
  }

  bool get hasReward => rewardType != 'none' && rewardValue != null && rewardValue!.isNotEmpty;
}

class UserWinPassProgressModel {
  final int currentStep;
  final int completedCycles;
  final bool canScan;
  final int cooldownRemainingSeconds;
  final String? nextRewardTitle;
  final String? nextRewardValue;
  final String? nextRewardType;

  UserWinPassProgressModel({
    required this.currentStep,
    required this.completedCycles,
    required this.canScan,
    required this.cooldownRemainingSeconds,
    this.nextRewardTitle,
    this.nextRewardValue,
    this.nextRewardType,
  });

  factory UserWinPassProgressModel.fromJson(Map<String, dynamic> json) {
    return UserWinPassProgressModel(
      currentStep: json['current_step'] ?? 0,
      completedCycles: json['completed_cycles'] ?? 0,
      canScan: json['can_scan'] ?? true,
      cooldownRemainingSeconds: json['cooldown_remaining_seconds'] ?? 0,
      nextRewardTitle: json['next_reward_title'],
      nextRewardValue: json['next_reward_value']?.toString(),
      nextRewardType: json['next_reward_type'],
    );
  }
}

class WinPassProgramModel {
  final bool hasWinPass;
  final int? programId;
  final int totalSteps;
  final int cooldownHours;
  final int cooldownMinutes;
  final double minBillAmount;
  final String currency;
  final List<WinPassStepModel> steps;
  final UserWinPassProgressModel? userProgress;

  WinPassProgramModel({
    required this.hasWinPass,
    this.programId,
    this.totalSteps = 10,
    this.cooldownHours = 1,
    this.cooldownMinutes = 50,
    this.minBillAmount = 0.0,
    this.currency = 'TL',
    this.steps = const [],
    this.userProgress,
  });

  factory WinPassProgramModel.fromJson(Map<String, dynamic> json) {
    if (json['has_win_pass'] != true) {
      return WinPassProgramModel(hasWinPass: false);
    }

    var stepsList = (json['steps'] as List<dynamic>?)
            ?.map((e) => WinPassStepModel.fromJson(e))
            .toList() ??
        [];

    return WinPassProgramModel(
      hasWinPass: true,
      programId: json['program_id'],
      totalSteps: json['total_steps'] ?? 10,
      cooldownHours: json['cooldown_hours'] ?? 1,
      cooldownMinutes: json['cooldown_minutes'] ?? 50,
      minBillAmount: (json['min_bill_amount'] != null) ? (json['min_bill_amount'] as num).toDouble() : 0.0,
      currency: json['currency'] ?? 'TL',
      steps: stepsList,
      userProgress: json['user_progress'] != null
          ? UserWinPassProgressModel.fromJson(json['user_progress'])
          : null,
    );
  }
}

class WinPassRedeemResult {
  final bool success;
  final String message;
  final int? stepNumber;
  final int? totalSteps;
  final String? rewardType;
  final String? rewardValue;
  final String? rewardTitle;
  final String? serverTime;
  final String? serverDate;
  final String? providerName;
  final int? completedCycles;

  WinPassRedeemResult({
    required this.success,
    required this.message,
    this.stepNumber,
    this.totalSteps,
    this.rewardType,
    this.rewardValue,
    this.rewardTitle,
    this.serverTime,
    this.serverDate,
    this.providerName,
    this.completedCycles,
  });

  factory WinPassRedeemResult.fromJson(Map<String, dynamic> json) {
    return WinPassRedeemResult(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      stepNumber: json['step_number'],
      totalSteps: json['total_steps'],
      rewardType: json['reward_type'],
      rewardValue: json['reward_value']?.toString(),
      rewardTitle: json['reward_title'],
      serverTime: json['server_time'],
      serverDate: json['server_date'],
      providerName: json['provider_name'],
      completedCycles: json['completed_cycles'],
    );
  }
}
