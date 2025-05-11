Given("I open the homepage") do
  visit "/new"
end

When("I submit the letter {string}") do |letter|
  fill_in "letter", with: letter
  click_button "Guess"
end

When("I submit {int} wrong letters") do |count|
  wrong_letters = %w[q w z x v b m]
  wrong_letters.first(count).each do |ch|
    fill_in "letter", with: ch
    click_button "Guess"
  end
end

When("I click the {string} button") do |text|
  click_button text
end

Then("I should see {string}") do |text|
  expect(page).to have_content(text)
end

Then("I should see a helpful clue") do
  expect(page).to have_content(/Hint:/i)  # يتحقق من أي نص يحتوي Hint: بحروف صغيرة أو كبيرة
end

Then("the background should change") do
  # اختبار تغيّر الخلفية بناءً على class
  current_class = page.evaluate_script("document.body.classList.contains('dark-mode')")
  expect(current_class).to be true
end
