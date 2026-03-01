# Sensors - User Guide

## 📳 Shake Detection Feature

### What is it?
Shake your phone anywhere in the app to quickly access creation actions!

### How to use:
1. **Shake** your phone with moderate force
2. **Wait** for the Quick Actions dialog to appear
3. **Select** what you want to create:
   - 📖 **Create Recipe** - Add a new recipe
   - 📦 **Add Material** - Add a new material to inventory
   - 🚚 **Add Supplier** - Add a new supplier
   - 🏭 **Start Production** - Begin a new production batch

### Tips:
- ✅ Shake with **moderate force** - not too gentle, not too hard
- ✅ Works **anywhere** in the app - dashboard, lists, forms, etc.
- ✅ Hold device **securely** to avoid dropping it
- ⚠️ Wait **2-3 seconds** between shakes (cooldown period)
- ⚠️ Works best on **physical devices** (not in emulators)

### Visual Feedback:
When shake is detected, you'll see:
1. A snackbar notification: "Shake detected! Opening quick actions..."
2. A beautiful dialog with 4 action buttons
3. Each button has an icon, title, and description

---

## 💡 Light Sensor Feature

### What is it?
The app automatically adjusts between light and dark theme based on ambient lighting!

### How it works:
- 🌙 **Dark Mode** activates automatically in low light (< 200 lux)
- ☀️ **Light Mode** activates automatically in bright light (> 500 lux)
- 📱 You'll see a notification when theme changes

### Where to see it:
- Look for the **lux indicator** in the app bar (small chip showing light level)
- The entire app theme will smoothly transition
- Colors, text, and UI elements adapt to the lighting

### Light Conditions:
| Lux Level | Description | Theme |
|-----------|-------------|-------|
| 0-100 | Very Dark (Night) | Dark Mode |
| 100-200 | Dark (Evening) | Dark Mode |
| 200-500 | Dim (Indoor) | Light Mode |
| 500-800 | Normal (Office) | Light Mode |
| 800-1000 | Bright (Outdoor) | Light Mode |

### Benefits:
- 👀 **Better visibility** in different lighting conditions
- 😌 **Reduced eye strain** at night
- 🔋 **Battery saving** (dark mode on OLED screens)
- 🎨 **Automatic adaptation** - no manual switching needed

---

## 🎯 Quick Tips

### For Best Experience:

**Shake Detection:**
- Use on physical devices for reliable detection
- Shake firmly but safely
- Perfect for power users who create items frequently

**Light Sensor:**
- Theme changes are smooth and automatic
- Notifications keep you informed
- Works on all platforms (simulated on web/desktop)

### Troubleshooting:

**Shake not working?**
- Ensure you're on a physical device (not emulator)
- Shake with more force
- Check that dialog isn't already open
- Wait for cooldown period (2-3 seconds)

**Theme not changing?**
- Light sensor may be simulating based on time
- Check the lux indicator in app bar
- Theme changes might be subtle on some screens

---

## 🎨 Visual Examples

### Shake Detection Flow:
```
1. [User shakes phone]
   ↓
2. [Snackbar appears: "Shake detected!"]
   ↓
3. [Quick Actions Dialog shows]
   ↓
4. [User taps an action]
   ↓
5. [Navigates to creation page]
```

### Light Sensor Flow:
```
1. [Light level changes]
   ↓
2. [Sensor detects change]
   ↓
3. [Theme switches automatically]
   ↓
4. [Notification shows: "Dark Mode Activated"]
   ↓
5. [All screens update with new theme]
```

---

## 💬 Feedback

Both sensors provide **immediate visual feedback**:

- **Shake**: Snackbar + Dialog
- **Light**: Snackbar + Theme change + Lux indicator

This ensures you always know when sensors are active and working!

---

**Enjoy your enhanced app experience! 🎉**
