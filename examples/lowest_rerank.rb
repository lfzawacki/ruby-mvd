# List all ligands sorted by lowest rerankscore
# swithout showing duplicate ligands

# Adjust this path to use with your experiments
require '../mvd'

results = MVD::ResultList.new('example.mvdresults')

# ligand name => renrankscore
dic = {}

# Finds the lowest rerankscore for each ligand
results.list.each do |r|
    # Initializes all ligand rerankscores to 0
    if dic[r.ligand] == nil
        dic[r.ligand] = 0
    end

    if r.rerankscore < dic[r.ligand]
        dic[r.ligand] = r.rerankscore
    end
end

# Turn it into an array and sort it by rerankscore
sorted = dic.to_a.sort_by { |x| x[1] }

# Pretty print
sorted.each do |s|
    puts "#{s[0]} #{s[1]}"
end