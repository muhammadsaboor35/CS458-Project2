const wdio = require("webdriverio");
const assert = require('assert');
const find = require('appium-flutter-finder');

//setting OS specific capabilities
const osSpecificOps = process.env.APPIUM_OS === 'android' ? {
  platformName: 'Android',
  deviceName: 'emulator-5554',
  app: __dirname +  "/../build/app/outputs/apk/debug/app-debug.apk"
}: process.env.APPIUM_OS === 'ios' ? {
  platformName: 'iOS',
  platformVersion: '14.4',
  deviceName: 'iPhone 12 Pro',
  noReset: true,
  app: __dirname +  '/../build/ios/Debug/Runner.app',
} : {};

//setting common capabilities
const opts = {
  port: 4723,
  capabilities: {
    ...osSpecificOps,
    automationName: 'Flutter'
  }
};

(async () => {
	
  //creating driver
  const driver = await wdio.remote(opts);
  await new Promise(resolve => setTimeout(resolve, 15000));
  
  //some common checks
  assert.strictEqual(await driver.execute('flutter:checkHealth'), 'ok');
  await driver.execute('flutter:clearTimeline');
  await driver.execute('flutter:forceGC');

  /*Test Case 1: */
  await driver.execute('flutter:waitFor', find.byValueKey('nameSurname'));
  await driver.elementSendKeys(find.byValueKey('nameSurname'), 'Muhammad Saboor');
  
  await driver.execute('flutter:waitFor', find.byValueKey('birthDate'));
  await driver.elementClick(find.byValueKey('birthDate'));
  await driver.elementClick(find.byText('1'));
  await driver.elementClick(find.byText('OK'));
  
  await driver.execute('flutter:waitFor', find.byValueKey('city'));
  await driver.elementSendKeys(find.byValueKey('city'), 'Ankara');
  
  await driver.execute('flutter:waitFor', find.byValueKey('gender'));
  await driver.elementClick(find.byValueKey('gender'));
  await driver.elementClick(find.byText('Male'));
  
  await driver.execute('flutter:waitFor', find.byValueKey('vaccineType'));
  await driver.elementClick(find.byValueKey('vaccineType'));
  await driver.elementClick(find.byText('Pfizer-BioNTech'));
  
  await driver.execute('flutter:waitFor', find.byValueKey('sideEffect'));
  await driver.elementSendKeys(find.byValueKey('sideEffect'), 'Cold');
  
  await driver.execute('flutter:waitFor', find.byValueKey('sendBtn'));
  console.log('Test 1 passed.');
  
  /*Test Case 2: */
  await driver.elementClick(find.byValueKey('sendBtn'));
  await driver.execute('flutter:waitFor', find.byText('Survey Accepted!\nThanks for attending!'));
  console.log('Test 2 passed.');

  /*Test Case 3: */
  await driver.execute('flutter:waitFor', find.byValueKey('OKbtn'));
  await driver.elementClick(find.byValueKey('OKbtn'));
  await driver.execute('flutter:waitFor', find.byText('Name Surname'));
  await driver.execute('flutter:waitFor', find.byText('Birth Date'));
  await driver.execute('flutter:waitFor', find.byText('City'));
  await driver.execute('flutter:waitFor', find.byText('Select Gender'));
  await driver.execute('flutter:waitFor', find.byText('Select Vaccine Type'));
  await driver.execute('flutter:waitFor', find.byText('Any Side Effects (Optional)'));
  console.log('Test 3 passed.');
  
  /*Test Case 4: */
  name = 'Muhammad Saboor';
  city = 'Ankara';
  gender = 'Male';
  vaccineType = 'Pfizer-BioNTech';
  side_effects = 'Cold and Fever';
  await driver.execute('flutter:waitFor', find.byValueKey('nameSurname'));
  await driver.elementSendKeys(find.byValueKey('nameSurname'), name);
  
  await driver.execute('flutter:waitFor', find.byValueKey('birthDate'));
  await driver.elementClick(find.byValueKey('birthDate'));
  await driver.elementClick(find.byText('1'));
  await driver.elementClick(find.byText('OK'));
  date = await driver.getElementText(find.byValueKey('birthDate'));
  
  await driver.execute('flutter:waitFor', find.byValueKey('city'));
  await driver.elementSendKeys(find.byValueKey('city'), city);
  
  await driver.execute('flutter:waitFor', find.byValueKey('gender'));
  await driver.elementClick(find.byValueKey('gender'));
  await driver.elementClick(find.byText(gender));
  
  await driver.execute('flutter:waitFor', find.byValueKey('vaccineType'));
  await driver.elementClick(find.byValueKey('vaccineType'));
  await driver.elementClick(find.byText(vaccineType));
  
  await driver.execute('flutter:waitFor', find.byValueKey('sideEffect'));
  await driver.elementSendKeys(find.byValueKey('sideEffect'), side_effects);
  
  await driver.switchContext('NATIVE_APP');
  await driver.background(1);
  await driver.switchContext('FLUTTER');

  assert.strictEqual(await driver.getElementText(find.byValueKey('nameSurname')),name);
  assert.strictEqual(await driver.getElementText(find.byValueKey('birthDate')),date);
  assert.strictEqual(await driver.getElementText(find.byValueKey('city')),city);
  assert.strictEqual(await driver.getElementText(find.byValueKey('sideEffect')),side_effects);
  
  console.log('Test 4 passed.');
  
  /*Test Case 5: */
  await driver.switchContext('NATIVE_APP');
  await driver.lock();
  await new Promise(resolve => setTimeout(resolve, 100));
  await driver.unlock();
  await driver.switchContext('FLUTTER');
  
  assert.strictEqual(await driver.getElementText(find.byValueKey('nameSurname')),name);
  assert.strictEqual(await driver.getElementText(find.byValueKey('birthDate')),date);
  assert.strictEqual(await driver.getElementText(find.byValueKey('city')),city);
  assert.strictEqual(await driver.getElementText(find.byValueKey('sideEffect')),side_effects);
  console.log('Test 5 passed.');
  driver.deleteSession();
})();