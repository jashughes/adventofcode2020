#= Load data =# 
pwords = readlines("02.txt")

#= Count matching characters =# 
function count_char(look_for, look_in)
    length(collect(eachmatch(Regex("$look_for"), look_in)))
end

#= Function to check both passwords requirements =#
function check_passwords(pwords)
    valid_part1, valid_part2 = 0, 0
    for i = 1:length(pwords)
        split_words = split(replace(pwords[i], ":" => ""))
        letter_count = count_char(split_words[2], split_words[3])
        specs = parse.(Int, split(split_words[1], "-"))
        
        if (letter_count >= specs[1] && letter_count <= specs[2])
            valid_part1 += 1
        end

        if count_char(split_words[2], split_words[3][specs]) == 1
            valid_part2 += 1
        end
    end
    return valid_part1, valid_part2
end

#= Solve =#
valid_part1, valid_part2 = check_passwords(pwords)
println("part 1: $valid_part1\npart 2: $valid_part2")

#= Part 1:
    The shopkeeper at the North Pole Toboggan Rental Shop is having a bad day. 
    "Something's wrong with our computers; we can't log in!" You ask if you can take a look.
    Their password database seems to be a little corrupted: some of the passwords wouldn't 
    have been allowed by the Official Toboggan Corporate Policy that was in effect when they were chosen.

    To try to debug the problem, they have created a list (your puzzle input) of passwords 
    (according to the corrupted database) and the corporate policy when that password was set.

    For example, suppose you have the following list:

        1-3 a: abcde
        1-3 b: cdefg
        2-9 c: ccccccccc

    Each line gives the password policy and then the password. The password policy indicates the lowest 
    and highest number of times a given letter must appear for the password to be valid. For example, 
    1-3 a means that the password must contain a at least 1 time and at most 3 times.

    In the above example, 2 passwords are valid. The middle password, cdefg, is not; it contains no instances 
    of b, but needs at least 1. The first and third passwords are valid: they contain one a or nine c, both 
    within the limits of their respective policies.

    How many passwords are valid according to their policies?
=#


#= Part 2:
    While it appears you validated the passwords correctly, they don't seem to be what the Official Toboggan 
    Corporate Authentication System is expecting.

    The shopkeeper suddenly realizes that he just accidentally explained the password policy rules from his old 
    job at the sled rental place down the street! The Official Toboggan Corporate Policy actually works a little 
    differently.

    Each policy actually describes two positions in the password, where 1 means the first character, 2 means the 
    second character, and so on. (Be careful; Toboggan Corporate Policies have no concept of "index zero"!) 
    Exactly one of these positions must contain the given letter. Other occurrences of the letter are irrelevant 
    for the purposes of policy enforcement.

    Given the same example list from above:

        1-3 a: abcde is valid: position 1 contains a and position 3 does not.
        1-3 b: cdefg is invalid: neither position 1 nor position 3 contains b.
        2-9 c: ccccccccc is invalid: both position 2 and position 9 contain c.

    How many passwords are valid according to the new interpretation of the policies?

=#


