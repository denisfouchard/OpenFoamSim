## OPENFOAM CASE - ATHENS 2024
## SIMPLIFIED AHMED BODY SIMULATION

# remove existing meshes
rm -r processor*
rm -r constant/polyMesh
rm -r 0

# build mesh
echo "Building mesh..."
blockMesh > blockMesh.log
echo "Mesh built."
echo "Building snappyHexMesh..."
surfaceFeatureExtract > surfaceFeatureExtract.log
decomposePar > decomposePar.log 											#decomposing the domain to run the case in pallel, on multiple cores, tp speed up the simulation
mpirun -np 4 snappyHexMesh -overwrite -parallel > snappyHexMesh.log
reconstructParMesh -constant > reconstructParMesh.log 						#reconstructing the mesh
echo "Checking mesh..."
checkMesh > checkMesh.log
echo "Mesh checked." 
# rm -r processor*															#remove the processors files, once the mesh is recontructed

# copy the initial/boudary conditions and run the case
rm -r 0
cp -r 0.orig 0
rm -r processor*
echo "Running the case..."
decomposePar -latestTime > decomposePar_run.log 							#decomposing again the domain to run the case in pallel, on multiple cores, tp speed up the simulation
echo "Starting the simulation..."
mpirun -np 4 simpleFoam -parallel > simpleFoam.log