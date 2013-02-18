module MVD

    DockSettings = Struct.new(:max_iterations, :runs, :ligands, :output_directory,
                              :ignore_similar_poses, :randomize_ligand, :max_poses, :rmsd,
                              :pose_output_format, :post_minimize, :post_optimize, :cluster_then_minimize,
                              :create_smiles, :pose_name_pattern)

    # The mvdresult header is this
    HEADER = "C0	CO2minus	Cofactor (VdW)	Cofactor (elec)	Cofactor (hbond)	Csp2	Csp3	DOF	E-Inter (cofactor - ligand)	E-Inter (protein - ligand)	E-Inter (water - ligand)	E-Inter total	E-Intra (clash)	E-Intra (elec)	E-Intra (hbond)	E-Intra (sp2-sp2)	E-Intra (steric)	E-Intra (tors)	E-Intra (tors, ligand atoms)	E-Intra (vdw)	E-Soft Constraint Penalty	E-Solvation	E-Total	Electro	ElectroLong	Energy	Filename	HBond	HeavyAtoms	LE1	LE3	Ligand	MW	N	Name	NoHBond90	Nplus	OH	OPO32minus	OS	PoseEnergy	RMSD	RerankScore	Run	SimilarityScore	Steric	Torsions	VdW (LJ12-6)	carbonyl	halogen	SMILES	PlantsScore"

    members = HEADER.split(/\t/).map do |member|
        member.downcase.gsub(/ - /,'_').gsub(/^e-([a-z]{5})(.*)$/,'e\1\2').gsub(/[\s+|-]/,'_').gsub(/\(|\)/,'').to_sym
    end

    Result = Struct.new(*members)

    class ResultList

        attr_reader :radius, :center, :random_seed

        def initialize file
            load(file)
        end

        def load file

            is_header = true
            lines = IO.read(file).split(/\n/)
            @list = []

            lines.each do |line|
                # Test for one of the first parameter lines
                # if match = line.match(/^# ([a-zA-Z ]+):\s*(.*)$/)
                if match = line.match(/^#.*$/)
                    # case match[1]

                    # when "Workspace File"

                    # when "DockSettings"

                    # when "Optimizer"

                    # when "Evaluator"

                    # when "Search Space"
                    #     # Radius: 15 Center: Vector[ 4.48 65.50 1.56 ]
                    #     # m = match[2].match /Radius: ([0-9.]+) Center: Vector[(.*)]/

                    #     # @search_space_radius = m[1].to_i
                    #     # @search_space_center = m[2].split.map(:to_i)

                    # when "The random seed used for this session is"
                    #     # @random_seed = m[2]
                    # end

                elsif is_header line
                    #ignore
                else
                    row = line.split(/\t/).map do |e|
                        try_to_f e
                    end
                    @list << Result.new(*row)
                end
            end

        end

        def list
            @list
        end

        # Converts string into a number representation or leaves
        # it as a string if it's not a number anyway
        def try_to_f str
            n = str.to_f

            # It's actually a string
            if n == 0 && str[0].chr != "0"
                str
            else
                n
            end
        end

        def is_header line
            line.chomp == MVD::HEADER
        end
    end
end
