#= Load data =# 

passports = readlines("04.txt", keep=true)

function tidy_passports(passports)
    tidy = []
    current_pass = Dict()
    for i = 1:length(passports)
        if passports[i] == "\r\n" || i == length(passports)
            tidy = Base.vcat(tidy, [current_pass])
            current_pass = Dict()
        else
            merge!(current_pass, Dict(split.(split(replace(passports[i], "\r\n" => "")), ":")))
        end
    end
    return tidy
end

function check_passports(passes, required)
    ok = 0
    for i = 1:length(passes)
        if check_fields(passes[i], required)
            ok += tightened_restrictions(passes[i])
        end
    end
    return ok
end

function check_fields(pass, required)
    all([r in keys(pass) for r in required])
end

function tightened_restrictions(pass)
    byr = 1920 ≤ parse(Int, pass["byr"]) ≤ 2002
    iyr = 2010 ≤ parse(Int, pass["iyr"]) ≤ 2020
    eyr = 2020 ≤ parse(Int, pass["eyr"]) ≤ 2030
    hgt = parse_height(pass["hgt"])
    hcl = occursin(r"#([a-f0-9]){6}", pass["hcl"])
    ecl = (pass["ecl"] in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])
    pid = occursin(r"^([0-9]){9}$", pass["pid"])
    all([byr, iyr, eyr, hgt, hcl, ecl, pid])
end

function parse_height(ht)
    ndigs = length(ht)
    unit = ht[[ndigs - 1, ndigs]]
    (unit == "in" && 59 ≤ parse(Int, ht[1:(ndigs - 2)]) ≤ 76 ) ||
     (unit == "cm" && 150 ≤ parse(Int, ht[1:(ndigs - 2)]) ≤ 193)
end

passes = tidy_passports(passports)
println(check_passports(passes, ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]))

#= --- Day 4: Passport Processing ---
--- Part One ---

You arrive at the airport only to realize that you grabbed your North Pole Credentials instead of your passport. While these 
documents are extremely similar, North Pole Credentials aren't issued by a country and therefore aren't actually valid documentation 
for travel in most of the world.

It seems like you're not the only one having problems, though; a very long line has formed for the automatic passport scanners, and the 
delay could upset your travel itinerary.

Due to some questionable network security, you realize you might be able to solve both of these problems at the same time.

The automatic passport scanners are slow because they're having trouble detecting which passports have all required fields. The expected
 fields are as follows:

    byr (Birth Year)
    iyr (Issue Year)
    eyr (Expiration Year)
    hgt (Height)
    hcl (Hair Color)
    ecl (Eye Color)
    pid (Passport ID)
    cid (Country ID)

Passport data is validated in batch files (your puzzle input). Each passport is represented as a sequence of key:value pairs separated by 
spaces or newlines. Passports are separated by blank lines.

Here is an example batch file containing four passports:

ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in

The first passport is valid - all eight fields are present. The second passport is invalid - it is missing hgt (the Height field).

The third passport is interesting; the only missing field is cid, so it looks like data from North Pole Credentials, not a 
passport at all! Surely, nobody would mind if you made the system temporarily ignore missing cid fields. Treat this "passport" as valid.

The fourth passport is missing two fields, cid and byr. Missing cid is fine, but missing any other field is not, so this 
passport is invalid.

According to the above rules, your improved system would report 2 valid passports.

Count the number of valid passports - those that have all required fields. Treat cid as optional. In your batch file, how many passports 
are valid?

Your puzzle answer was 242.
--- Part Two ---

The line is moving more quickly now, but you overhear airport security talking about how passports with invalid data are getting 
through. Better add some data validation, quick!

You can continue to ignore the cid field, but each other field has strict rules about what values are valid for automatic validation:

    byr (Birth Year) - four digits; at least 1920 and at most 2002.
    iyr (Issue Year) - four digits; at least 2010 and at most 2020.
    eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
    hgt (Height) - a number followed by either cm or in:
        If cm, the number must be at least 150 and at most 193.
        If in, the number must be at least 59 and at most 76.
    hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
    ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
    pid (Passport ID) - a nine-digit number, including leading zeroes.
    cid (Country ID) - ignored, missing or not.

Count the number of valid passports - those that have all required fields and valid values. Continue to treat cid as optional. 
In your batch file, how many passports are valid?

=#
