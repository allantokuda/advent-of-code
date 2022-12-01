import sys

# Non-essential: user friendliness
if (len(sys.argv) != 2):
    print >> sys.stderr, "USAGE: {} inputfile".format(__file__)
    sys.exit(1)

# Boilerplate: file read
with open(sys.argv[1]) as f:
    filedata = f.read()

# Sums (shared parts 1 and 2)
groups = filedata.split("\n\n")
group_sum = lambda text: sum(map(int, text.splitlines()))
sums = map(group_sum, groups)

# Part 1
print max(sums)

# Part 2
print sum(sorted(sums)[-3:])
