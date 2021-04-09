# Dockerized [CirComPara2](http://github.com/egaffo/circompara2)

[CirComPara2](http://github.com/egaffo/circompara2): Improved bioinformatic pipeline to identify and quantify circRNA expression from RNA-seq data by combining multiple circRNA detection methods.[^CirComPara2]   

## Usage

Docker pull command:

```bash
docker pull egaffo/circompara2
```

Run command example:
	
```bash
docker run --rm -it -v $(pwd):/data egaffo/circompara2
```

Mind that all files must be in the current directory and that paths in `meta.csv` and `vars.py` must be relative to the container `/data` directory. For instance, using the test data, you have to copy the `annotation` and `reads` directories into the `analysis` directory. Then, `meta.csv` will be as follows:  

    file,sample,adapter  
    /data/reads/readsA_1.fastq.gz,sample_A,/CirComPara/tools/Trimmomatic-0.39/adapters/TruSeq3-PE-2.fa  
    /data/reads/readsA_2.fastq.gz,sample_A,/CirComPara/tools/Trimmomatic-0.39/adapters/TruSeq3-PE-2.fa  
    /data/reads/readsB_1.fastq.gz,sample_B,/CirComPara/tools/Trimmomatic-0.39/adapters/TruSeq3-PE-2.fa  
    /data/reads/readsB_2.fastq.gz,sample_B,/CirComPara/tools/Trimmomatic-0.39/adapters/TruSeq3-PE-2.fa  

and `vars.py`:  

```python
META            = "meta.csv"
GENOME_FASTA    = '/data/annotation/CFLAR_HIPK3.fa'
ANNOTATION      = '/data/annotation/CFLAR_HIPK3.gtf' 
```

The results will be owned by `root`. If you want the container to give your user permissions try to use the "-u `id -u`" workaround:

```bash
docker run -u `id -u` --rm -it -v $(pwd):/data egaffo/circompara2
```

# How to cite

If you used the docker image of CirComPara for your analysis, please add the following citation to your references:  
  
[^CirComPara2]: Title [http://][circompara2_article]


[circompara2_article]: http://

