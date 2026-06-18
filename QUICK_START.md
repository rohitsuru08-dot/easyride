# 🚀 Modern Design System - Quick Start Guide

## Import & Use in 30 Seconds

### Single Import for Everything
```dart
import 'package:easy_ride/widgets/design_system.dart';
import 'package:easy_ride/core/constants/app_constants.dart';
```

---

## Common Patterns

### 1. Modern Buttons

```dart
// Basic button
ModernButton(
  label: 'Continue',
  onPressed: () => Navigator.push(context, MaterialPageRoute(
    builder: (context) => NextScreen(),
  )),
)

// Loading state
ModernButton(
  label: 'Submit',
  onPressed: () {},
  isLoading: true,
)

// With gradient
GradientButton(
  label: 'Premium Action',
  onPressed: () {},
  gradient: AppConstants.premiumGradient,
  icon: Icons.arrow_forward,
)

// Disabled
ModernButton(
  label: 'Disabled',
  onPressed: () {},
  isDisabled: true,
)
```

### 2. Modern Text Fields

```dart
// Standard field
ModernTextField(
  label: 'Email Address',
  hint: 'Enter your email',
  prefixIcon: Icons.email,
  keyboardType: TextInputType.emailAddress,
)

// Glass field
ModernTextField(
  label: 'Password',
  hint: 'Enter password',
  obscureText: true,
  isGlass: true,
  suffixIcon: Icons.visibility,
)

// With validation
ModernTextField(
  label: 'Phone Number',
  controller: _phoneController,
  validator: (value) {
    if (value?.isEmpty ?? true) return 'Required';
    if (value!.length != 10) return 'Must be 10 digits';
    return null;
  },
  prefixIcon: Icons.phone,
)
```

### 3. Glass Cards

```dart
// Standard glass card
GlassmorphismCard(
  child: Padding(
    padding: EdgeInsets.all(AppConstants.spacing16),
    child: Column(
      children: [
        Text('Glass Effect', style: AppConstants.headingMedium),
        SizedBox(height: AppConstants.spacing8),
        Text('With blur background'),
      ],
    ),
  ),
)

// Premium glass card
PremiumGlassCard(
  gradient: AppConstants.premiumGradient,
  onTap: () => print('Tapped!'),
  child: Container(
    height: 150,
    child: Center(
      child: Text('Tap me!', style: AppConstants.headingSmall),
    ),
  ),
)
```

### 4. Premium Cards

```dart
// Elevated card
PremiumCard(
  style: PremiumCardStyle.elevated,
  onTap: () {},
  isHoverable: true,
  child: Padding(
    padding: EdgeInsets.all(AppConstants.spacing16),
    child: ListTile(
      leading: Icon(Icons.directions_bus),
      title: Text('Bus Details'),
      subtitle: Text('Route: AB123'),
    ),
  ),
)

// Outlined card
PremiumCard(
  style: PremiumCardStyle.outlined,
  borderColor: AppConstants.primaryBlue,
  child: Container(
    height: 100,
    child: Center(child: Text('Outlined')),
  ),
)

// Gradient card
GradientCard(
  gradient: AppConstants.sunsetGradient,
  onTap: () {},
  child: Padding(
    padding: EdgeInsets.all(AppConstants.spacing16),
    child: Column(
      children: [
        Text('Gradient', style: TextStyle(color: Colors.white)),
        Text('Card', style: TextStyle(color: Colors.white70)),
      ],
    ),
  ),
)
```

### 5. Modern App Bar

```dart
// Simple app bar
ModernAppBar(
  title: 'Home',
  actions: [
    IconButton(
      icon: Icon(Icons.notifications),
      onPressed: () {},
    ),
  ],
)

// Glass app bar
ModernAppBar(
  title: 'Dashboard',
  isGlass: true,
  blurAmount: 15,
)

// Gradient app bar
GradientAppBar(
  title: 'Premium Screen',
  gradient: AppConstants.premiumGradient,
  actions: [
    IconButton(
      icon: Icon(Icons.menu),
      onPressed: () {},
    ),
  ],
)
```

### 6. Animations

```dart
// Fade in
FadeInAnimation(
  child: YourWidget(),
  duration: AppConstants.animationNormalDuration,
)

// Slide from bottom
SlideInAnimation(
  direction: SlideDirection.up,
  child: YourWidget(),
)

// Zoom in
ScaleInAnimation(
  beginScale: 0.8,
  child: YourWidget(),
)

// Pulse effect
PulseAnimation(
  child: Icon(Icons.star, color: AppConstants.primaryBlue),
)

// Loading shimmer
ShimmerLoading(
  child: Container(
    height: 100,
    color: Colors.grey[300],
  ),
)

// Bouncing
BounceAnimation(
  infinite: true,
  child: Icon(Icons.favorite, color: AppConstants.accentPink),
)
```

### 7. Gradient Background

```dart
// Static gradient
Container(
  decoration: BoxDecoration(
    gradient: AppConstants.premiumGradient,
  ),
  child: YourContent(),
)

// Animated gradients
AnimatedGradientContainer(
  gradients: [
    AppConstants.premiumGradient,
    AppConstants.sunsetGradient,
    AppConstants.forestGradient,
  ],
  duration: Duration(seconds: 3),
  child: Container(
    height: 200,
    child: Center(child: Text('Animated')),
  ),
)

// Gradient background mesh
GradientMeshBackground(
  gradient: AppConstants.premiumGradient,
  animate: true,
  child: YourContent(),
)
```

---

## Colors Quick Reference

```dart
// Primary
AppConstants.primaryBlue        // #0066FF
AppConstants.primaryGreen       // #00D084

// Accents
AppConstants.accentPurple       // #7C3AED
AppConstants.accentOrange       // #FF6B35
AppConstants.accentPink         // #FF006E

// Semantic
AppConstants.errorColor         // #EF4444
AppConstants.successColor       // #10B981
AppConstants.warningColor       // #F59E0B
AppConstants.infoColor          // #3B82F6

// Backgrounds
AppConstants.backgroundColor    // #F7F9FC
AppConstants.surfaceColor       // #FAFBFC
AppConstants.cardBackground     // White

// Text
AppConstants.textPrimary        // #0F1419
AppConstants.textSecondary      // #52575C
AppConstants.textTertiary       // #909396
```

---

## Spacing Quick Reference

```dart
AppConstants.spacing2           // 2px
AppConstants.spacing4           // 4px
AppConstants.spacing6           // 6px
AppConstants.spacing8           // 8px
AppConstants.spacing12          // 12px
AppConstants.spacing16          // 16px (default)
AppConstants.spacing20          // 20px
AppConstants.spacing24          // 24px
AppConstants.spacing32          // 32px
AppConstants.spacing40          // 40px
AppConstants.spacing48          // 48px
```

---

## Typography Quick Reference

```dart
// Display
AppConstants.displayLarge       // 32px, Bold
AppConstants.displayMedium      // 28px, Bold
AppConstants.displaySmall       // 24px, Bold

// Headings
AppConstants.headingLarge       // 20px, Bold
AppConstants.headingMedium      // 18px, SemiBold
AppConstants.headingSmall       // 16px, SemiBold

// Body
AppConstants.bodyLarge          // 16px, Medium
AppConstants.bodyMedium         // 14px, Medium
AppConstants.bodySmall          // 12px, Medium

// Labels
AppConstants.labelLarge         // 14px, Bold
AppConstants.labelMedium        // 12px, SemiBold
AppConstants.labelSmall         // 11px, SemiBold

// Captions
AppConstants.captionLarge       // 12px, Regular
AppConstants.captionSmall       // 10px, Regular
```

---

## Complete Screen Example

```dart
import 'package:flutter/material.dart';
import 'package:easy_ride/widgets/design_system.dart';
import 'package:easy_ride/core/constants/app_constants.dart';

class BookingScreen extends StatefulWidget {
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModernAppBar(
        title: 'Book Your Ticket',
        isGlass: true,
      ) as PreferredSizeWidget?,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppConstants.spacing16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              FadeInAnimation(
                child: GradientCard(
                  gradient: AppConstants.premiumGradient,
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.all(AppConstants.spacing16),
                    child: Column(
                      children: [
                        Text(
                          'Easy Booking',
                          style: AppConstants.headingLarge.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: AppConstants.spacing8),
                        Text(
                          'Book your bus ticket in seconds',
                          style: AppConstants.bodyMedium.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppConstants.spacing24),

              // Form Fields
              SlideInAnimation(
                direction: SlideDirection.up,
                child: ModernTextField(
                  label: 'Full Name',
                  hint: 'Enter your name',
                  controller: _nameController,
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: AppConstants.spacing16),

              SlideInAnimation(
                direction: SlideDirection.up,
                child: ModernTextField(
                  label: 'Phone Number',
                  hint: 'Enter 10-digit number',
                  controller: _phoneController,
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter phone number';
                    }
                    if (value!.length != 10) {
                      return 'Must be 10 digits';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: AppConstants.spacing24),

              // Bus Selection Card
              PremiumCard(
                style: PremiumCardStyle.outlined,
                isHoverable: true,
                child: ListTile(
                  leading: Icon(Icons.directions_bus,
                      color: AppConstants.primaryBlue),
                  title: Text('Select Bus', style: AppConstants.bodyMedium),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {},
                ),
              ),
              SizedBox(height: AppConstants.spacing24),

              // Submit Button
              GradientButton(
                label: 'Continue to Payment',
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _isLoading = true);
                          Future.delayed(Duration(seconds: 2), () {
                            setState(() => _isLoading = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Booking confirmed!'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          });
                        }
                      },
                icon: Icons.payment,
                gradient: AppConstants.premiumGradient,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
```

---

## Tips & Tricks

1. **Consistent Spacing**
   ```dart
   // ✅ Good
   padding: EdgeInsets.all(AppConstants.spacing16),
   
   // ❌ Bad
   padding: EdgeInsets.all(15.0),
   ```

2. **Reuse Gradients**
   ```dart
   // ✅ Good
   gradient: AppConstants.premiumGradient,
   
   // ❌ Bad (Define new every time)
   gradient: LinearGradient(colors: [...]),
   ```

3. **Use Text Styles**
   ```dart
   // ✅ Good
   Text('Title', style: AppConstants.headingMedium),
   
   // ❌ Bad (Inline styles)
   Text('Title', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
   ```

4. **Chain Animations**
   ```dart
   SlideInAnimation(
     child: FadeInAnimation(
       child: YourWidget(),
     ),
   )
   ```

5. **Consistent Colors**
   ```dart
   // ✅ Use constants
   color: AppConstants.primaryBlue,
   
   // ❌ Hard-coded colors
   color: Color(0xFF0066FF),
   ```

---

## Performance Notes

- All animations are properly disposed
- Shadows are pre-calculated
- Glass blur is optimized
- No memory leaks
- Safe for production use

---

## Accessibility

- High contrast ratios
- Touch targets > 48x48 points
- Clear visual feedback
- Readable font sizes
- Semantic colors for meaning

---

**Ready to build beautiful UIs! 🎨✨**

For detailed documentation, see `DESIGN_SYSTEM.md`
