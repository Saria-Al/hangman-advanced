Given("I open the homepage") do
  visit "/new"
end

When("I submit the letter {string}") do |letter|
  fill_in "letter", with: letter
  click_button "Guess"
end

When("I submit {int} wrong letters") do |count|
  # قائمة من الحروف التي غالباً لا تكون ضمن الكلمات الشائعة
  fallback_wrong_letters = %w[q x z j v w k u y]
  submitted = 0

  fallback_wrong_letters.each do |letter|
    break if submitted >= count

    # نتأكد أن هذا الحرف لم يُستخدم بعد
    unless page.body.include?(letter)
      fill_in "letter", with: letter
      click_button "Guess"
      sleep 0.3  # يساعد في استقرار نتائج Capybara مع تغيّر الصفحة
      submitted += 1
    end
  end
end

When("I click the {string} button") do |text|
  click_button text
end

Then("I should see a loss message") do
  expect(page).to have_content(/You lost/i)
end

Then("I should see a helpful clue") do
  expect(page).to have_selector('#hint-text', text: /Hint:/i)
end

Then("the background should change") do
  current_class = page.evaluate_script("document.body.classList.contains('dark-mode')")
  expect(current_class).to be true
end
