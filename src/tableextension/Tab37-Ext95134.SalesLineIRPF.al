/// <summary>
/// TableExtension SalesLineIRPF (ID 80134) extends Record Sales Line.
/// </summary>
tableextension 95134 SalesLineIRPF extends "Sales Line" //37
{
    fields
    {
        field(92000; "% retención (BE)"; Decimal)
        {
            DataClassification = ToBeClassified;

            Caption = '% retención (BE)';
        }
        field(92001; "% retención (IRPF)"; Decimal)
        {
            DataClassification = ToBeClassified;
            //CaptionML=[ENU=On Hold % (IRPF);
            Caption = '% retención (IRPF)';
        }
        field(92002; "Importe retención (BE)"; Decimal)
        {
            DataClassification = ToBeClassified;

            Caption = 'Importe retención (BE)';
        }
        field(92003; "Importe retención (IRPF)"; Decimal)
        {
            DataClassification = ToBeClassified;

            Caption = 'Importe retención (IRPF)';
        }

    }


}