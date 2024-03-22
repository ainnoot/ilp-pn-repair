# https://github.com/maet3608/minimal-setup-py/blob/master/setup.py
from setuptools import setup, find_packages
from ipl import __version__

setup(
    name='Temp Package Name',
    version='.'.join(str(x) for x in __version__),
    url='https://github.com/xyz.git',
    author='Author Name',
    author_email='author@gmail.com',
    description='Description of my package',
    packages=find_packages(),
    install_requires=[],
)
