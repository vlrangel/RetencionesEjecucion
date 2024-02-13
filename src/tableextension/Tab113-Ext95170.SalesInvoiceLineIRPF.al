/// <summary>
/// TableExtension Sales Invoice LineIRPF (ID 80170) extends Record Sales Invoice Line.
/// </summary>
tableextension 95170 "Sales Invoice LineIRPF" extends "Sales Invoice Line" //113
{
    fields
    {
        field(92000; "% retención (BE)"; Decimal)
        {
            DataClassification = ToBeClassified;

            Caption = '% retención (BE)';
            Editable = false;
        }
        field(92001; "% retención (IRPF)"; Decimal)
        {
            DataClassification = ToBeClassified;

            Caption = '% retención (IRPF)';
            Editable = false;
        }
        field(92002; "Importe retención (BE)"; Decimal)
        {
            DataClassification = ToBeClassified;

            Caption = 'Importe retención (BE)';
            Editable = false;
        }
        field(92003; "Importe retención (IRPF)"; Decimal)
        {
            DataClassification = ToBeClassified;

            Caption = 'Importe retención (IRPF)';
            Editable = false;
        }
    }
}