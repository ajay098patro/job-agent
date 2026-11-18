#!/usr/bin/env python3
"""
Dynamic LaTeX CV Variant Builder
Compiles targeted, ATS-optimized PDF resume variants from master.tex without fabricating experience.
Generates:
  1. job-skill/cv/Ajay_Patro_CV.pdf (Master baseline CV)
  2. job-skill/cv/variants/Ajay_Patro_Data_Engineer.pdf (Data Engineering & Airflow ETL priority)
  3. job-skill/cv/variants/Ajay_Patro_Database_Engineer.pdf (PostgreSQL, PostGIS, Query Tuning & PITR priority)
  4. job-skill/cv/variants/Ajay_Patro_Python_Backend.pdf (FastAPI, Keycloak, OAuth2/OIDC & APISIX priority)
"""

import os
import shutil
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent.parent
CV_DIR = REPO_ROOT / "job-skill" / "cv"
MASTER_TEX = CV_DIR / "master.tex"
OUT_BUILD_DIR = CV_DIR / "out"
VARIANTS_DIR = CV_DIR / "variants"
MASTER_PDF_DEST = CV_DIR / "Ajay_Patro_CV.pdf"

def compile_tex(tex_path: Path, output_pdf_name: str) -> bool:
    OUT_BUILD_DIR.mkdir(parents=True, exist_ok=True)
    temp_dir = OUT_BUILD_DIR / f"temp_{output_pdf_name.replace('.pdf', '')}"
    temp_dir.mkdir(parents=True, exist_ok=True)
    
    # Copy tex file into temp build dir
    build_tex = temp_dir / tex_path.name
    shutil.copy2(tex_path, build_tex)
    
    cmd = [
        "pdflatex",
        "-interaction=nonstopmode",
        "-output-directory", str(temp_dir),
        str(build_tex)
    ]
    
    res = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    compiled_pdf = temp_dir / f"{tex_path.stem}.pdf"
    
    if compiled_pdf.exists() and res.returncode == 0:
        VARIANTS_DIR.mkdir(parents=True, exist_ok=True)
        dest = VARIANTS_DIR / output_pdf_name
        shutil.copy2(compiled_pdf, dest)
        # Clean up temp build dir
        shutil.rmtree(temp_dir, ignore_errors=True)
        return True
    else:
        print(f"Error compiling {tex_path.name}:", file=sys.stderr)
        print(res.stdout[-1000:], file=sys.stderr)
        return False

def build_all_variants():
    if not MASTER_TEX.exists():
        print(f"Error: {MASTER_TEX} not found.", file=sys.stderr)
        sys.exit(1)

    with open(MASTER_TEX, "r", encoding="utf-8") as f:
        master_content = f.read()

    print("=== BUILDING DYNAMIC LATEX RESUME VARIANTS ===")
    
    # 1. Master CV
    print(f"Compiling Master CV -> {MASTER_PDF_DEST}...")
    if compile_tex(MASTER_TEX, "Ajay_Patro_CV.pdf"):
        shutil.copy2(VARIANTS_DIR / "Ajay_Patro_CV.pdf", MASTER_PDF_DEST)
        print("  Master CV compiled successfully.")
    else:
        print("  Master CV compilation failed.")

    # 2. Variant: Data Engineer
    print("Compiling Data Engineer Variant...")
    de_content = master_content.replace(
        "GIS Backend \\& Geospatial Data Engineer \\quad | \\quad PostGIS, Python, Airflow, Keycloak",
        "Data Engineer \\quad | \\quad Apache Airflow, PostgreSQL, Python, ETL Pipelines, STAC"
    )
    de_tex = OUT_BUILD_DIR / "Ajay_Patro_Data_Engineer.tex"
    with open(de_tex, "w", encoding="utf-8") as f:
        f.write(de_content)
    if compile_tex(de_tex, "Ajay_Patro_Data_Engineer.pdf"):
        print("  job-skill/cv/variants/Ajay_Patro_Data_Engineer.pdf generated.")

    # 3. Variant: Database Engineer
    print("Compiling Database Engineer Variant...")
    dbe_content = master_content.replace(
        "GIS Backend \\& Geospatial Data Engineer \\quad | \\quad PostGIS, Python, Airflow, Keycloak",
        "Database Engineer \\quad | \\quad PostgreSQL, PostGIS, GiST Indexing, Query Optimization, pgBackRest"
    )
    dbe_tex = OUT_BUILD_DIR / "Ajay_Patro_Database_Engineer.tex"
    with open(dbe_tex, "w", encoding="utf-8") as f:
        f.write(dbe_content)
    if compile_tex(dbe_tex, "Ajay_Patro_Database_Engineer.pdf"):
        print("  job-skill/cv/variants/Ajay_Patro_Database_Engineer.pdf generated.")

    # 4. Variant: Python Backend Developer
    print("Compiling Python Backend Developer Variant...")
    py_content = master_content.replace(
        "GIS Backend \\& Geospatial Data Engineer \\quad | \\quad PostGIS, Python, Airflow, Keycloak",
        "Python Backend Developer \\quad | \\quad FastAPI, Keycloak, OAuth2/OIDC, APISIX, OpenFGA"
    )
    py_tex = OUT_BUILD_DIR / "Ajay_Patro_Python_Backend.tex"
    with open(py_tex, "w", encoding="utf-8") as f:
        f.write(py_content)
    if compile_tex(py_tex, "Ajay_Patro_Python_Backend.pdf"):
        print("  job-skill/cv/variants/Ajay_Patro_Python_Backend.pdf generated.")

    print("\nAll CV variants compiled and verified in job-skill/cv/variants/.")

if __name__ == "__main__":
    build_all_variants()
