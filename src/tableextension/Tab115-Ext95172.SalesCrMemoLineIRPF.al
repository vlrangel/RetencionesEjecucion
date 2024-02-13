/// <summary>
/// TableExtension Sales Cr.Memo LineIRPF (ID 80172) extends Record Sales Cr.Memo Line.
/// </summary>
tableextension 95172 "Sales Cr.Memo LineIRPF" extends "Sales Cr.Memo Line" //115
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
