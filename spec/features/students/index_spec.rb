require 'rails_helper'

describe 'As a visitor' do
  describe "When I visit '/students'" do
    before :each do
      @snape = Professor.create(name: "Severus Snape", age: 45, specialty: "Potions")
      @hagarid = Professor.create(name: "Rubeus Hagrid", age: 38, specialty: "Care of Magical Creatures")
      @lupin = Professor.create(name: "Remus Lupin", age: 49, specialty: "Defense Against The Dark Arts")

      @harry = Student.create(name: "Harry Potter", age: 11, house: "Gryffindor")
      @malfoy = Student.create(name: "Draco Malfoy", age: 12, house: "Slytherin")
      @longbottom = Student.create(name: "Neville Longbottom", age: 11, house: "Gryffindor")

      ProfessorStudent.create(student_id: @harry.id, professor_id: @snape.id)
      ProfessorStudent.create(student_id: @harry.id, professor_id: @hagarid.id)
      ProfessorStudent.create(student_id: @harry.id, professor_id: @lupin.id)
      ProfessorStudent.create(student_id: @malfoy.id, professor_id: @hagarid.id)
      ProfessorStudent.create(student_id: @malfoy.id, professor_id: @lupin.id)
      ProfessorStudent.create(student_id: @longbottom.id, professor_id: @snape.id)
    end

    it 'I see a list of students and the number of professors each student has.' do
      visit students_path

      within("#student-#{@malfoy.id}") do
        expect(page).to have_content(@malfoy.name)
        expect(page).to have_content("Num of professors: 2")
      end

      within("#student-#{@harry.id}") do
        expect(page).to have_content(@harry.name)
        expect(page).to have_content("Num of professors: 3")
      end

      within("#student-#{@longbottom.id}") do
        expect(page).to have_content(@longbottom.name)
        expect(page).to have_content("Num of professors: 1")
      end
    end

    it 'sorts students alphabetically' do
      visit students_path
      expect(current_path).to eq(students_path)

      expect(all('.student-name')[0].text).to eq(@malfoy.name)
      expect(all('.student-name')[1].text).to eq(@harry.name)
      expect(all('.student-name')[2].text).to eq(@longbottom.name)
    end
  end
end