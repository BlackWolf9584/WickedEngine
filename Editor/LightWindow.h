#pragma once

struct Material;
class wiGUI;
class wiWindow;
class wiLabel;
class wiCheckBox;
class wiSlider;
class wiButton;
class wiColorPicker;
class wiComboBox;

struct Light;

class LightWindow
{
public:
	LightWindow(wiGUI* gui);
	~LightWindow();

	wiGUI* GUI;

	void SetLight(Light* light);
	void SetLightType(Light::LightType type);

	Light* light;

	wiWindow*	lightWindow;
	wiSlider*	energySlider;
	wiSlider*	distanceSlider;
	wiSlider*	radiusSlider;
	wiSlider*	widthSlider;
	wiSlider*	heightSlider;
	wiSlider*	fovSlider;
	wiSlider*	biasSlider;
	wiCheckBox*	shadowCheckBox;
	wiCheckBox*	haloCheckBox;
	wiCheckBox*	volumetricsCheckBox;
	wiButton*	addLightButton;
	wiColorPicker*	colorPicker;
	wiComboBox*	typeSelectorComboBox;
};

