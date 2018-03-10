---
layout: post
title: "What is a Ruby Hash?"
date: 2013-08-19
preview: looking at the Ruby Hash as a C program
---

The only answer that matters is:

 
                   static VALUE
    rb_hash_s_create(int argc, VALUE *argv, VALUE klass)
    {
        VALUE hash, tmp;
        int i;

        if (argc == 1) {
            tmp = rb_hash_s_try_convert(Qnil, argv[0]);
            if (!NIL_P(tmp)) {
                hash = hash_alloc(klass);
                if (RHASH(tmp)->ntbl) {
                    RHASH(hash)->ntbl = st_copy(RHASH(tmp)->ntbl);
                }
                return hash;
            }

            tmp = rb_check_array_type(argv[0]);
            if (!NIL_P(tmp)) {
                long i;

                hash = hash_alloc(klass);
                for (i = 0; i < RARRAY_LEN(tmp); ++i) {
                    VALUE e = RARRAY_AREF(tmp, i);
                    VALUE v = rb_check_array_type(e);
                    VALUE key, val = Qnil;

                    if (NIL_P(v)) {
    #if 0 /* refix in the next release */
                        rb_raise(rb_eArgError, "wrong element type %s at %ld (expected array)",
                                 rb_builtin_class_name(e), i);

    #else
                        rb_warn("wrong element type %s at %ld (expected array)",
                                rb_builtin_class_name(e), i);
                        rb_warn("ignoring wrong elements is deprecated, remove them explicitly");
                        rb_warn("this causes ArgumentError in the next release");
                        continue;
    #endif
                    }
                    switch (RARRAY_LEN(v)) {
                      default:
                        rb_raise(rb_eArgError, "invalid number of elements (%ld for 1..2)",
                                 RARRAY_LEN(v));
                      case 2:
                        val = RARRAY_AREF(v, 1);
                      case 1:
                        key = RARRAY_AREF(v, 0);
                        rb_hash_aset(hash, key, val);
                    }
                }
                return hash;
            }
        }
        if (argc % 2 != 0) {
            rb_raise(rb_eArgError, "odd number of arguments for Hash");
        }

        hash = hash_alloc(klass);
        for (i=0; i<argc; i+=2) {
            rb_hash_aset(hash, argv[i], argv[i + 1]);
        }

        return hash;
    }

Read more about it [here](https://github.com/ruby/ruby/blob/trunk/hash.c).
