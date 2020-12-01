with open("01.txt") as f:
    expenses = f.readlines()
expenses = [int(x.rstrip("\n")) for x in expenses]

for i in range(0, len(expenses)):
    for j in range(i, len(expenses)):
        if (expenses[i] + expenses[j]) == 2020:
                print("part 1:", expenses[i] * expenses[j])
        for k in range(j, len(expenses)):
            if (expenses[i] + expenses[j] + expenses[k]) == 2020:
                print("part 2:", expenses[i] * expenses[j] * expenses[k])

