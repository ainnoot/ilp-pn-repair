import sys
from ilp_petri_net_repair import ContextDependentExample, trace_example, extract_variants
from argparse import ArgumentParser

def parse_args():
    parser = ArgumentParser(prog="reify_log", description="Reifies a XES event log into a set of ILASP examples.")
    parser.add_argument('log', type=str, help="Path to XES file.")

    return parser.parse_args()


if __name__ == '__main__':
    args = parse_args()
    log = args.log

    variants, _ = extract_variants(log)

    for eid, (variant, _) in enumerate(variants.items()):
        e = trace_example(variant, f'example_{eid}', True)
        print(e)
