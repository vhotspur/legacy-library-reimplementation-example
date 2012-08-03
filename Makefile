
LEGACY_CFLAGS = -Ilegacy
OBJCOPY = objcopy
CFLAGS = -Wall -Werror
CC = gcc
LD = gcc
AR = ar

DISTNAME = func_renaming

COLLISION_FILE = legacy/collisions

LIBREVISED_REDEFINES = \
	$(shell ./create_redefines.sh 'n' 's/.*/__revised_&/' <$(COLLISION_FILE))
LIBLEGACY_REDEFINES_PHASE_ONE = \
	$(shell ./create_redefines.sh 'n' 's/.*/__revised_&/' <$(COLLISION_FILE))
LIBLEGACY_REDEFINES_PHASE_TWO = \
	$(shell ./create_redefines.sh 's/.*/legacy_&/' 'n' <$(COLLISION_FILE))
	
	

.PHONY: all clean .patch_revised .patch_self

.SECONDARY:

all: app

run: app
	./app

app: ported/app.o liblegacy.a
	$(LD) -o $@ $^  

revised/librevised.a: revised/system.o revised/compute.o
	$(AR) rcs $@ $^

legacy/liblegacy.a: legacy/delta.o legacy/system.o
	$(AR) rcs $@ $^
	
liblegacy.a: .patch_revised .patch_self
	$(AR) rcs $@ legacy/patched_revised/*.o legacy/patched_self/*.o

$(COLLISION_FILE): legacy/*.h
	cat $^ \
		| sed -n -e '/^#/d' -e 's/__LEGACY__/\n&/gp' \
		| sed -n -e 's/__LEGACY__(\([^)]*\)).*/\1/p' \
		| sort -u \
		> $@

.patch_revised: revised/librevised.a $(COLLISION_FILE)
	cd legacy/patched_revised; \
		rm -f *; \
		$(AR) x ../../$<; \
		for f in *.o; do \
			echo "Patching $$f..."; \
			$(OBJCOPY) $(LIBREVISED_REDEFINES) $$f $$f; \
		done

.patch_self: legacy/liblegacy.a $(COLLISION_FILE)
	cd legacy/patched_self; \
		rm -f *; \
		$(AR) x ../../$<; \
		for f in *.o; do \
			echo "Patching $$f..."; \
			$(OBJCOPY) $(LIBLEGACY_REDEFINES_PHASE_ONE) $$f $$f; \
			$(OBJCOPY) $(LIBLEGACY_REDEFINES_PHASE_TWO) $$f $$f; \
		done

ported/%.o: ported/%.c
	$(CC) -c $(CFLAGS) $(LEGACY_CFLAGS) -o $@ $<

%.o: %.c
	$(CC) -c $(CFLAGS) -o $@ $<

dist:
	mkdir $(DISTNAME)
	mkdir $(DISTNAME)/legacy $(DISTNAME)/legacy/patched_revised $(DISTNAME)/legacy/patched_self $(DISTNAME)/ported $(DISTNAME)/revised
	
	cp Makefile create_redefines.sh $(DISTNAME)
	cp legacy/*.[hc] legacy/aliases $(DISTNAME)/legacy
	cp ported/*.[hc] $(DISTNAME)/ported
	cp revised/*.[hc] $(DISTNAME)/revised
	
	tar czf $(DISTNAME).tar.gz $(DISTNAME)
	
	rm -rf $(DISTNAME)

clean:
	find -name '*.o' -or -name 'lib*.a' -delete
	rm -f app legacy/collisions
	
