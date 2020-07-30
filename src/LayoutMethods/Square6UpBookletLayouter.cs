﻿using System;
using PdfSharp.Drawing;
using PdfSharp.Pdf;

namespace PdfDroplet.LayoutMethods
{
    /// <summary>
    /// Layout a 6up square booklet that will be folded vertically and cut horizontally.  The actual
    /// paper will be treated as portrait to fit the 6 square pages.  (Vertical cuts may be needed
    /// to trim the actual pages, which are laid out centered vertically but aligned to the top of
    /// the paper.)
    /// </summary>
    /// <remarks>
    /// Similarly to how the SideFold4UpBookletLayouter produces 2 copies of the booklet, this
    /// layout method produces 3 copies of the booklet.
    /// </remarks>
    public class Square6UpBookletLayouter : LayoutMethod
    {
        public Square6UpBookletLayouter():base("square6UpBooklet.png")
        {

        }

        public override string ToString()
        {
            return "Fold/Cut 6Up Square Booklet";
        }

		/// <summary>
		/// 6up layout requires portrait orientation of the paper.
		/// This method achieves that happy state.
		/// </summary>
		protected override void SetPaperSize(PaperTarget paperTarget)
		{
			var size = paperTarget.GetPaperDimensions(_inputPdf.PixelHeight, _inputPdf.PixelWidth);
			_paperWidth = size.X;
			_paperHeight = size.Y;
		}

		protected override void LayoutInner(PdfDocument outputDocument, int numberOfSheetsOfPaper, int numberOfPageSlotsAvailable, int vacats)
        {
			for (var idx = 1; idx <= numberOfSheetsOfPaper; idx++)
            {
	            XGraphics gfx;
				// Front page of a sheet:
				using (gfx = GetGraphicsForNewPage(outputDocument))
				{
					//Left side of front
					if (vacats > 0) // Skip if left side has to remain blank
						vacats -= 1;
					else
						DrawSuperiorSide(gfx, numberOfPageSlotsAvailable + 2 * (1 - idx));

					//Right side of the front
					DrawInferiorSide(gfx, 2 * idx - 1);
				}

				// Back page of a sheet
				using (gfx = GetGraphicsForNewPage(outputDocument))
				{
					if (2 * idx <= _inputPdf.PageCount) //prevent asking for page 2 with a single page document (JH Oct 2010)
						//Left side of back
						DrawSuperiorSide(gfx, 2 * idx);

					//Right side of the Back
					if (vacats > 0) // Skip if right side has to remain blank
						vacats -= 1;
					else
						DrawInferiorSide(gfx, numberOfPageSlotsAvailable + 1 - 2 * idx);
				}
			}
		}

        private void DrawInferiorSide(XGraphics gfx, int pageNumber)
        {
            var leftEdge = LeftEdgeForInferiorPage;
            var boxSize = _paperWidth / 2;
            if (_inputPdf.PointWidth < _paperWidth / 2)
            {
                if (Math.Abs(leftEdge) < 0.01)
                    leftEdge = (_paperWidth / 2) - _inputPdf.PointWidth;
                boxSize = _inputPdf.PointWidth;
            }
            _inputPdf.PageNumber = pageNumber;
			var box = new XRect(leftEdge, 0, boxSize, boxSize);
			gfx.DrawImage(_inputPdf, box);
            _inputPdf.PageNumber = pageNumber;
            box = new XRect(leftEdge, boxSize, boxSize, boxSize);
            gfx.DrawImage(_inputPdf, box);
            _inputPdf.PageNumber = pageNumber;
            box = new XRect(leftEdge, 2 * boxSize, boxSize, boxSize);
            gfx.DrawImage(_inputPdf, box);
		}

		private void DrawSuperiorSide(XGraphics gfx, int pageNumber)
		{
            var leftEdge = LeftEdgeForSuperiorPage;
            var boxSize = _paperWidth / 2;
            if (_inputPdf.PointWidth < _paperWidth / 2)
            {
                if (Math.Abs(leftEdge) < 0.01)
                    leftEdge = (_paperWidth / 2) - _inputPdf.PointWidth;
                boxSize = _inputPdf.PointWidth;
            }
			_inputPdf.PageNumber = pageNumber;
			var box = new XRect(leftEdge, 0, boxSize, boxSize);
			gfx.DrawImage(_inputPdf, box);
            _inputPdf.PageNumber = pageNumber;
            box = new XRect(leftEdge, boxSize, boxSize, boxSize);
            gfx.DrawImage(_inputPdf, box);
            _inputPdf.PageNumber = pageNumber;
            box = new XRect(leftEdge, 2* boxSize, boxSize, boxSize);
            gfx.DrawImage(_inputPdf, box);
		}

        public override bool GetIsEnabled(XPdfForm inputPdf)
        {
            // Available only for square input pages.
            return IsSquare(inputPdf);
        }
    }
}
