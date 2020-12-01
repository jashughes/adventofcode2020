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