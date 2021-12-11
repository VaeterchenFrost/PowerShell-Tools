Import-Module assert
(Split-Path -Path (Get-Module assert).path ) + '\Format\src\Format.psm1' | Import-Module
New-Alias nice Format-Collection

function node-project {
    git init
    npx license $(npm get init.license) -o "$(npm get init.author.name)" > LICENSE
    npx gitignore node
    npx covgen "$(npm get init.author.email)"
    npm init -y
    git add -A
    git commit -m 'Initial commit'
}

function conda {
    powershell.exe -ExecutionPolicy ByPass -NoExit -Command "& 'C:\ProgramData\Anaconda3\shell\condabin\conda-hook.ps1' ; conda activate 'C:\ProgramData\Anaconda3' "    
}

$equal_tempered_scale = @{Eb2 = 77.78; E2 = 82.41; F2 = 87.31; Gb2 = 92.50; G2 = 98.00; Ab2 = 103.83; A2 = 110.00; Bb2 = 116.54; B2 = 123.47; C3 = 130.81; Db3 = 138.59; D3 = 146.83; Eb3 = 155.56; E3 = 164.81; F3 = 174.61; Gb3 = 185.00; G3 = 196.00; Ab3 = 207.65; A3 = 220.00; Bb3 = 233.08; B3 = 246.94; C4 = 261.63; Db4 = 277.18; D4 = 293.66; Eb4 = 311.13; E4 = 329.63; F4 = 349.23; Gb4 = 369.99; G4 = 392.00; Ab4 = 415.30; A4 = 440.00; Bb4 = 466.16; B4 = 493.88; C5 = 523.25; Db5 = 554.37; D5 = 587.33; Eb5 = 622.25; E5 = 659.25; F5 = 698.46; Gb5 = 739.99; G5 = 783.99; Ab5 = 830.61; A5 = 880.00; Bb5 = 932.33; B5 = 987.77; C6 = 1046.50; Db6 = 1108.73; D6 = 1174.66; Eb6 = 1244.51; E6 = 1318.51; F6 = 1396.91; Gb6 = 1479.98; G6 = 1567.98; Ab6 = 1661.22; A6 = 1760.00; Bb6 = 1864.66; B6 = 1975.53 }

#  @('a4','a4','bb4','d4','g4','bb4','c5','f4','a4','bb4','bb4','g4','bb4','d5','eb5','g4','d5','c5')|%{[System.Console]::Beep($equal_tempered_scale[$_],430)}
