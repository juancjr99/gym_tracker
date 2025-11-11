# Testing the Routine Creation Flow

## Overview
This document provides instructions for testing the complete routine creation and workout execution flow.

## Prerequisites
- App running in development mode
- Database initialized with seed exercises

## If Exercises Don't Appear

If the exercise selector shows "No exercises found", the database needs to be reset:

### Option 1: Delete Database File Manually
**macOS:**
```bash
rm ~/Library/Containers/com.example.gymTracker.development/Data/Library/Application\ Support/gym_tracker.db
```

**iOS Simulator:**
```bash
# Find the app container
xcrun simctl get_app_container booted com.example.gymTracker.development data
# Then delete gym_tracker.db from that path
```

**Android Emulator:**
```bash
adb shell
run-as com.example.gym_tracker.development
rm databases/gym_tracker.db
```

### Option 2: Add Reset Button (Development Only)
Add this temporary button to your app during development:

```dart
// In your settings or debug page
ElevatedButton(
  onPressed: () async {
    await SeedHelper.resetDatabase();
    // Restart the app or reinitialize database
    exit(0); // Force restart
  },
  child: Text('Reset Database & Seed Data'),
)
```

## Testing Steps

### 1. Verify Seed Data Loaded
1. Open the app
2. Check console logs for:
   ```
   Database onOpen called - checking exercises
   Found X exercises in database
   ```
3. If count is 0, check for:
   ```
   No exercises found - inserting defaults
   Inserting 28 default exercises
   Successfully inserted 28 exercises
   ```

### 2. Create a Routine
1. Navigate to Routines tab
2. Tap "Create Routine" or "+" button
3. Fill in basic information:
   - Name: e.g., "Push Day"
   - Description: e.g., "Chest, shoulders, and triceps"
4. Verify no difficulty/type selectors appear (simplified UI)
5. Scroll to "Exercises" section

### 3. Add Exercises
1. Tap "Add Exercise" button (below exercise list)
2. Verify exercise selector shows 28 exercises
3. Test search functionality:
   - Type "press" → should show Press Banca, Press Inclinado, Press Militar, etc.
   - Clear search → all exercises return
4. Test filters:
   - Select "Weight" type → only weight exercises
   - Select "Chest" muscle group → chest exercises
   - Clear filters
5. Select an exercise (e.g., "Press Banca")
6. Configure exercise:
   - Sets: 3
   - Reps: 12
   - Weight: 60 kg
   - Rest: 90 seconds
7. Tap "Add to Routine"

### 4. Add More Exercises
Repeat step 3 to add:
- Press Inclinado (3 sets x 10 reps x 50kg)
- Aperturas con Mancuernas (3 sets x 15 reps x 20kg)
- Flexiones (3 sets x max reps, bodyweight)

### 5. Test Reordering
1. Verify each exercise shows up/down arrow buttons
2. First exercise: down arrow enabled, up arrow disabled
3. Last exercise: up arrow enabled, down arrow disabled
4. Middle exercises: both arrows enabled
5. Click down arrow on first exercise → moves to position 2
6. Click up arrow on last exercise → moves up one position
7. Test drag-and-drop reordering (if implemented)

### 6. Test Circuit Button (Placeholder)
1. Tap "Add Circuit" button
2. Verify placeholder dialog appears
3. Close dialog

### 7. Add Tags
1. Scroll to "Tags" section
2. Add tags: "Push", "Strength", "Upper Body"
3. Verify each tag appears as a chip
4. Test removing tags by tapping X

### 8. Save Routine
1. Tap "Save Routine" button (top right)
2. Verify success message appears
3. Navigate back to routines list
4. Verify new routine appears with:
   - Name "Push Day"
   - 4 exercises shown
   - Tags displayed

### 9. Start Workout
1. Tap on the created routine
2. Tap "Start Workout" button
3. Verify WorkoutSessionPage loads
4. Check header shows:
   - Routine name
   - Total elapsed time (timer running)
   - Exercise navigation (1 of 4)

### 10. Execute Workout
For each exercise:
1. Verify exercise info card shows:
   - Exercise name
   - Muscle groups
   - Planned sets/reps/weight
2. For each set:
   - Enter actual weight, reps (pre-filled with planned values)
   - Tap "Complete Set"
   - Verify rest timer starts automatically
   - Option to skip or pause rest
3. Complete all sets for the exercise
4. Tap "Next Exercise" (or swipe)
5. Repeat for all exercises

### 11. Finish Workout
1. After completing all exercises, tap "Finish Workout"
2. Verify confirmation dialog
3. Confirm finish
4. Verify workout is saved
5. Check workout history shows the completed workout

### 12. Verify Data Persistence
1. Close and reopen the app
2. Navigate to routines → verify routine exists
3. Navigate to workout history → verify completed workout exists
4. Check workout details:
   - Date/time
   - Total duration
   - Exercises completed
   - Actual sets/reps/weight recorded

## Expected Behavior

### Exercise Selector
- ✅ Shows 28 default exercises on first load
- ✅ Search filters exercises by name
- ✅ Type filter shows only matching exercise types
- ✅ Muscle group filter shows only matching exercises
- ✅ Selecting exercise opens configuration sheet
- ✅ Configuration is pre-filled based on exercise type

### Exercise Configuration
- **Weight exercises**: Sets, Reps, Weight, Rest
- **Bodyweight exercises**: Sets, Reps, Rest (no weight field)
- **Time exercises**: Sets, Duration, Rest (no reps/weight)
- **Combined exercises**: Sets, Reps, Weight, Duration, Rest

### Reordering
- ✅ Arrow buttons work correctly
- ✅ Boundary conditions respected (first/last)
- ✅ Order updates immediately in UI
- ✅ Order persists when saving routine

### Workout Execution
- ✅ Timer starts automatically on workout start
- ✅ Rest timer auto-starts after completing set
- ✅ Navigation between exercises works
- ✅ Actual values can differ from planned
- ✅ All data saves correctly on finish

## Troubleshooting

### No exercises in selector
→ Database not seeded. Reset database (see "If Exercises Don't Appear")

### Exercises don't save
→ Check BLoC events in console
→ Verify RoutineBloc receives CreateRoutineEvent
→ Check database write permissions

### Workout doesn't save
→ Verify all sets completed
→ Check WorkoutBloc receives SaveWorkoutEvent
→ Check console for errors

### Timer not working
→ Check WorkoutSessionPage state
→ Verify Timer is not disposed prematurely

## Success Criteria
- ✅ All 28 seed exercises appear in selector
- ✅ Routine creation completes without errors
- ✅ Exercises can be added, configured, and reordered
- ✅ Routine saves and persists across app restarts
- ✅ Workout execution records all data correctly
- ✅ Workout history shows completed workout with details
