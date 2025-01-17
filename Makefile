# Copyright 2023 Bahman Movaqar
#
# This file is part of bjForth.
#
# bjForth is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# bjForth is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License
# along with bjForth. If not, see <https://www.gnu.org/licenses/>.
####################################################################################################

SHELL := /usr/bin/env bash
.DEFAULT_GOAL := test

####################################################################################################

export ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
export root.src = $(ROOT)src/
export root.bjForth = $(ROOT)bjForth/

####################################################################################################

export bjForth.version := v0.0.5

####################################################################################################

.PHONY : bmakelib/bmakelib.mk
include  bmakelib/bmakelib.mk

####################################################################################################

.PHONY : test

test :
	@echo Testing...OK.

####################################################################################################

.PHONY : bjForth.setup

bjForth-setup : bmakelib.error-if-blank( bjForth.version )
bjForth-setup :
	@[ -d $(root.bjForth) ] \
	  || { \
	    wget https://github.com/bahmanm/bjforth/releases/download/$(bjForth.version)/bjForth-$(bjForth.version).tar -O bjforth.tar \
	    && mkdir -p $(root.bjForth) && tar -xf bjforth.tar -C $(root.bjForth) \
	    && rm bjforth.tar ; \
	  }

####################################################################################################

.PHONY : chapter-1.0

chapter-1.0 : bjForth-setup
chapter-1.0 :
	cd $(root.bjForth) \
	&& ./bjForth \
	  $(root.src)lib/invoice-line.forth \
	  $(root.src)lib/invoice.forth \
	  $(root.src)lib/invoice-db.forth \
	  $(root.src)lib/invoice-csv.forth \
	  $(root.src)chapter-1.0.forth

####################################################################################################

.PHONY : chapter-2.0

chapter-2.0 : bjForth-setup
chapter-2.0 :
	@cd $(root.bjForth) \
	&& ./bjForth \
	  $(root.src)lib/invoice-line.forth \
	  $(root.src)lib/invoice.forth \
	  $(root.src)lib/invoice-db.forth \
	  $(root.src)lib/invoice-csv.forth \
	  $(root.src)chapter-2.0.forth


####################################################################################################

.PHONY : run

run : bmakelib.default-if-blank( SOURCE, )
run : bjForth-run.source := $(SOURCE)
run : bjForth-run

####################################################################################################

.PHONY : clean

clean :
	@rm -rf $(root.bjForth)
