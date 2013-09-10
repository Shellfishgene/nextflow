/*
 * Copyright (c) 2013, the authors.
 *
 *   This file is part of 'Nextflow'.
 *
 *   Nextflow is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   Nextflow is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Nextflow.  If not, see <http://www.gnu.org/licenses/>.
 */



params.in = '~/sample.fa'
SPLIT = (System.properties['os.name'] == 'Mac OS X' ? 'gcsplit' : 'csplit')

process split {
    input:
    file 'query.fa' using file(params.in)

    output:
    file 'seq_*' using splits joint true

    """
    $SPLIT query.fa '%^>%' '/^>/' '{*}' -f seq_
    """
}


process printTwo {
    echo true

    input:
    file 'chunk' using splits

    output:
    file 'chunk1:chunk3' using two_chunks

    """
    cat chunk* | rev
    """

}

process printLast {
    echo true

    input:
    file 'chunk' using two_chunks

    output:
    file 'chunk' using result

    """
    cat chunk
    """
}