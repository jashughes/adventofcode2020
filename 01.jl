#= Part 1:
    The Elves in accounting need you to fix your expense report (your puzzle input); apparently, 
    something isn't quite adding up.

    Specifically, they need you to find the two entries that sum to 2020 and then multiply those 
    two numbers together.

    For example, suppose your expense report contained the following:

    1721
    979
    366
    299
    675
    1456

    In this list, the two entries that sum to 2020 are 1721 and 299. Multiplying them together 
    produces 1721 * 299 = 514579, so the correct answer is 514579.

    Of course, your expense report is much larger. Find the two entries that sum to 2020; 
    what do you get if you multiply them together?

=# 

#= Part 2:

    The Elves in accounting are thankful for your help; one of them even offers you a starfish 
    coin they had left over from a past vacation. They offer you a second one if you can find 
    three numbers in your expense report that meet the same criteria.

    Using the above example again, the three entries that sum to 2020 are 979, 366, and 675. 
    Multiplying them together produces the answer, 241861950.

    In your expense report, what is the product of the three entries that sum to 2020?
=#



expenses = parse.(Int, readlines("01.txt"))

for i = 1:length(expenses)
    for j = i:length(expenses)
        if expenses[i] + expenses[j] == 2020
            println("part 1: $(expenses[i] * expenses[j])")
        end
        for k = j:length(expenses)
            if expenses[i] + expenses[j] + expenses[k] == 2020
                println("part 2: $(expenses[i] * expenses[j] * expenses[k])")
            end
        end
    end
end



