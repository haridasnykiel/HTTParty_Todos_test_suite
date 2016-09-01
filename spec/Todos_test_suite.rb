require './spec_helper.rb'

describe "Todos API" do

  before :all do
    @driver = HTTParty.get "http://lacedeamon.spartaglobal.com/todos"
    @test_data1 = YAML.load_file("test_data.yml")["test_data1"]
  end

  after :all do
    puts "        Your tests are successful        "
  end

  it "load YAML file" do
    expect(@test_data1.to_a.size).to eq 3
    expect(@test_data1["title"]).to eq "Haridas POST tests"
    expect(@test_data1["due"]).to eq "2015-02-06"
  end

  it "Should be able to POST to Todos" do

    post = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query: {title: @test_data1["title"], due: @test_data1["due"]}
    id = post["id"]
    get_post = HTTParty.get "http://lacedeamon.spartaglobal.com/todos/#{id}"
    expect(get_post["title"]).to eq "Haridas POST tests"

  end

  it "Should not post if the title is more than 3000 characters or the title is empty" do

    post = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query: {title: @test_data1["title"] * 3000, due: @test_data1["due"]}
    expect(post.message).to eq "Request-URI Too Long"

  end

  it "Should be able to Read an item in Todos" do

    get = HTTParty.get "http://lacedeamon.spartaglobal.com/todos/7625"
    expect(get["title"]).to eq "Sosa"

  end

  it "Should error if an incorrect id is provided" do

    get = HTTParty.get "http://lacedeamon.spartaglobal.com/todos/-92310738921748921"
    expect(get.message).to eq "Internal Server Error"

  end

  it "Should be able to update an item in Todos" do

    update = HTTParty.patch "http://lacedeamon.spartaglobal.com/todos/7772", query: {title: @test_data1["title1"]}
    get = HTTParty.get "http://lacedeamon.spartaglobal.com/todos/7772"

    expect(get["title"]).to eq "Updated title Hari"

  end

  it "Should error if an incorrect item is being given, when get is called" do

    update = HTTParty.patch "http://lacedeamon.spartaglobal.com/todos/-129401249", query: {title: @test_data1["title1"]}
    expect(update.message).to eq "Not Found"

  end

  it "Should be able to delete an item in the api" do

    delete = HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/7399"
    get = HTTParty.get "http://lacedeamon.spartaglobal.com/todos/7399"
    expect(get.message).to eq "Not Found"

  end

  it "Should error if an incorrect id is given" do

    delete = HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/-399321074"
    expect(delete.message).to eq "Not Found"

  end

end
